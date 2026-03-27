-- Trivy LSP Wrapper - Workspace-wide diagnostics for trivy security scanning
-- This module runs trivy scans and publishes diagnostics for all files in the workspace
-- allowing Telescope and other tools to see diagnostics for unopened files

local M = {}

M.namespace = vim.api.nvim_create_namespace("trivy_workspace")

local severity_map = {
	LOW = vim.diagnostic.severity.INFO,
	MEDIUM = vim.diagnostic.severity.WARN,
	HIGH = vim.diagnostic.severity.ERROR,
	CRITICAL = vim.diagnostic.severity.ERROR,
}

-- Returns false for cache directories and remote module URIs
local function is_real_path(path)
	if not path or path == "" then
		return false
	end
	if path:match("%.terragrunt%-cache") or path:match("%.terraform") then
		return false
	end
	if path:match("^github%.com/") or path:match("^gitlab%.com/") or path:match("^bitbucket%.org/") then
		return false
	end
	if path:match("%?ref=") then
		return false
	end
	return true
end

-- Resolves a misconfiguration to a {file, line} pair using the real call-site.
-- Trivy 0.67+ maps remote/cache findings back to the actual source file via
-- CauseMetadata.Occurrences; falls back to Target + CauseMetadata.StartLine
-- for direct local file results.
local function resolve_location(result, misconf)
	local cm = misconf.CauseMetadata
	local occurrences = cm and cm.Occurrences

	if occurrences and #occurrences > 0 then
		for _, occ in ipairs(occurrences) do
			if is_real_path(occ.Filename) then
				return occ.Filename, occ.Location and occ.Location.StartLine
			end
		end
	end

	if is_real_path(result.Target) and result.Target:match("%.tf$") then
		return result.Target, cm and cm.StartLine
	end
end

function M.scan_workspace(opts)
	opts = opts or {}
	local cwd = opts.cwd or vim.fn.getcwd()

	local trivy_config = vim.fs.find("trivy.yaml", {
		path = cwd,
		upward = true,
		stop = vim.fn.expand("~"),
	})[1]

	local args = { vim.fn.expand("~/.local/share/nvim/mason/bin/trivy"), "config" }

	if trivy_config then
		vim.list_extend(args, { "--config", trivy_config })
	end

	vim.list_extend(args, { "--format", "json", "--quiet", cwd })

	vim.system(args, { text = true, cwd = cwd }, function(result)
		vim.schedule(function()
			-- trivy exits 1 when misconfigurations are found, 0 when clean; 2+ is a real error
			if result.code == 0 or result.code == 1 then
				M.process_results(result.stdout, cwd)
			else
				vim.notify("Trivy: Scan failed - " .. (result.stderr or "unknown error"), vim.log.levels.ERROR)
			end
		end)
	end)
end

function M.process_results(stdout, cwd)
	local ok, data = pcall(vim.json.decode, stdout)
	if not ok or not data or not data.Results then
		vim.notify("Trivy: Failed to parse results", vim.log.levels.WARN)
		return
	end

	vim.diagnostic.reset(M.namespace)

	local diagnostics_by_file = {}
	local total_issues = 0

	for _, result in ipairs(data.Results) do
		if result.Misconfigurations then
			for _, misconf in ipairs(result.Misconfigurations) do
				local rel_path, line = resolve_location(result, misconf)
				if rel_path then
					local abs_path = vim.fn.fnamemodify(cwd .. "/" .. rel_path, ":p")
					if not diagnostics_by_file[abs_path] then
						diagnostics_by_file[abs_path] = {}
					end
					-- trivy line numbers are 1-based; nvim diagnostics are 0-based
					local lnum = math.max(0, (line or 1) - 1)
					table.insert(diagnostics_by_file[abs_path], {
						lnum = lnum,
						col = 0,
						end_lnum = lnum,
						end_col = 0,
						message = misconf.Message or misconf.Description,
						code = misconf.ID,
						severity = severity_map[misconf.Severity] or vim.diagnostic.severity.ERROR,
						source = "trivy",
					})
					total_issues = total_issues + 1
				end
			end
		end
	end

	for filepath, diags in pairs(diagnostics_by_file) do
		local bufnr = vim.fn.bufadd(filepath)
		vim.fn.bufload(bufnr)
		vim.diagnostic.set(M.namespace, bufnr, diags, {})
	end

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

function M.setup()
	vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
		pattern = { "*.tf", "*.hcl", "*.tfvars" },
		callback = function()
			M.scan_workspace()
		end,
		group = vim.api.nvim_create_augroup("TrivyWorkspace", { clear = true }),
	})

	vim.api.nvim_create_user_command("TrivyScan", function()
		M.scan_workspace()
	end, { desc = "Run trivy workspace scan" })

	vim.api.nvim_create_user_command("TrivyClear", function()
		vim.diagnostic.reset(M.namespace)
		vim.notify("Trivy: Cleared all diagnostics", vim.log.levels.INFO)
	end, { desc = "Clear trivy diagnostics" })
end

return M
