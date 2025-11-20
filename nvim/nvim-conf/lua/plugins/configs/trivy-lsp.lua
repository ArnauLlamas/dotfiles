-- Trivy LSP Wrapper - Workspace-wide diagnostics for trivy security scanning
-- This module runs trivy scans and publishes diagnostics for all files in the workspace
-- allowing Telescope and other tools to see diagnostics for unopened files

local M = {}

-- Create a dedicated namespace for trivy diagnostics
M.namespace = vim.api.nvim_create_namespace("trivy_workspace")

-- Run trivy scan and publish diagnostics
function M.scan_workspace(opts)
	opts = opts or {}
	local cwd = opts.cwd or vim.fn.getcwd()

	-- Get trivy command from mason
	local trivy_cmd = vim.fn.expand("~/.local/share/nvim/mason/bin/trivy")

	-- Search for trivy.yaml upwards from current directory
	local trivy_config = vim.fs.find("trivy.yaml", {
		path = cwd,
		upward = true,
		stop = vim.fn.expand("~"), -- Stop at home directory
	})[1] -- Get first match

	-- Build trivy command args
	local trivy_args = {
		trivy_cmd,
		"config",
	}

	-- Only add --config flag if trivy.yaml was found
	if trivy_config then
		table.insert(trivy_args, "--config")
		table.insert(trivy_args, trivy_config)
	end

	-- Add remaining args
	table.insert(trivy_args, "--format")
	table.insert(trivy_args, "json")
	table.insert(trivy_args, "--quiet")
	table.insert(trivy_args, cwd)

	-- Show notification that scan is starting
	-- vim.notify("Trivy: Starting workspace scan...", vim.log.levels.INFO)

	-- Run trivy asynchronously
	vim.system(trivy_args, {
		text = true,
		cwd = cwd,
	}, function(result)
		vim.schedule(function()
			if result.code == 0 then
				M.process_results(result.stdout, cwd)
				-- vim.notify("Trivy: Scan complete", vim.log.levels.INFO)
			else
				vim.notify("Trivy: Scan failed - " .. (result.stderr or "unknown error"), vim.log.levels.ERROR)
			end
		end)
	end)
end

function M.process_results(stdout, cwd)
	-- Parse JSON
	local ok, data = pcall(vim.json.decode, stdout)
	if not ok or not data or not data.Results then
		vim.notify("Trivy: Failed to parse results", vim.log.levels.WARN)
		return
	end

	-- Clear all previous diagnostics in this namespace
	vim.diagnostic.reset(M.namespace)

	-- Group diagnostics by file
	local diagnostics_by_file = {}
	local total_issues = 0

	for _, result in ipairs(data.Results) do
		local filepath = result.Target

		-- Skip cache directories
		if not filepath or filepath:match("%.terraform") or filepath:match("%.terragrunt%-cache") then
			goto continue
		end

		if result.Misconfigurations then
			-- Convert to absolute path
			local abs_path = vim.fn.fnamemodify(cwd .. "/" .. filepath, ":p")

			if not diagnostics_by_file[abs_path] then
				diagnostics_by_file[abs_path] = {}
			end

			for _, misconf in ipairs(result.Misconfigurations) do
				local line = (misconf.CauseMetadata and misconf.CauseMetadata.StartLine or 1) - 1

				local severity_map = {
					LOW = vim.diagnostic.severity.INFO,
					MEDIUM = vim.diagnostic.severity.WARN,
					HIGH = vim.diagnostic.severity.ERROR,
					CRITICAL = vim.diagnostic.severity.ERROR,
				}

				table.insert(diagnostics_by_file[abs_path], {
					lnum = line,
					col = 0,
					end_lnum = line,
					end_col = 0,
					message = misconf.Message or misconf.Description,
					code = misconf.ID,
					severity = severity_map[misconf.Severity] or vim.diagnostic.severity.ERROR,
					source = "trivy",
				})

				total_issues = total_issues + 1
			end
		end

		::continue::
	end

	-- Publish diagnostics for all files
	for filepath, diags in pairs(diagnostics_by_file) do
		-- Get or create buffer for this file
		local bufnr = vim.fn.bufnr(filepath, false)

		if bufnr == -1 then
			-- File not loaded - use uri_to_bufnr to create virtual buffer
			local uri = vim.uri_from_fname(filepath)
			bufnr = vim.uri_to_bufnr(uri)
			-- Load the file into the buffer so diagnostics can be attached
			vim.fn.bufload(bufnr)
		end

		-- Set diagnostics
		vim.diagnostic.set(M.namespace, bufnr, diags, {})
	end

	-- Show summary
	-- local file_count = vim.tbl_count(diagnostics_by_file)
	-- if total_issues > 0 then
	-- 	vim.notify(
	-- 		string.format("Trivy: Found %d issue(s) in %d file(s)", total_issues, file_count),
	-- 		vim.log.levels.WARN
	-- 	)
	-- else
	-- 	vim.notify("Trivy: No issues found", vim.log.levels.INFO)
	-- end
end

-- Setup function
function M.setup()
	-- Create autocommand for terraform files (triggers on open and save)
	vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
		pattern = { "*.tf", "*.hcl", "*.tfvars" },
		callback = function()
			M.scan_workspace()
		end,
		group = vim.api.nvim_create_augroup("TrivyWorkspace", { clear = true }),
	})

	-- Create user command
	vim.api.nvim_create_user_command("TrivyScan", function()
		M.scan_workspace()
	end, { desc = "Run trivy workspace scan" })

	-- Create command to clear trivy diagnostics
	vim.api.nvim_create_user_command("TrivyClear", function()
		vim.diagnostic.reset(M.namespace)
		vim.notify("Trivy: Cleared all diagnostics", vim.log.levels.INFO)
	end, { desc = "Clear trivy diagnostics" })
end

return M
