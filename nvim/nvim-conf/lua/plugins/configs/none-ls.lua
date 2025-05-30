-- Create an augroup that is used for managing our formatting autocmds.
-- We need one augroup per client to make sure that multiple clients
-- can attach to the same buffer without interfering with each other.
local _augroups = {}
local get_augroup = function(client)
	if not _augroups[client.id] then
		local group_name = "none-ls-format-" .. client.name
		local id = vim.api.nvim_create_augroup(group_name, { clear = true })
		_augroups[client.id] = id
	end

	return _augroups[client.id]
end

local format_is_enabled = true
vim.api.nvim_create_user_command("FormattingToggle", function()
	format_is_enabled = not format_is_enabled
	print("Setting autoformatting to: " .. tostring(format_is_enabled))
end, {})

vim.api.nvim_create_user_command("FormattingDisable", function()
	format_is_enabled = false
end, {})

vim.api.nvim_create_user_command("FormattingEnable", function()
	format_is_enabled = true
end, {})

local none_ls = require("null-ls")

local opts = {
	sources = {
		-- Python
		none_ls.builtins.formatting.black,
		-- Go
		none_ls.builtins.formatting.gofumpt,
		none_ls.builtins.formatting.goimports_reviser,
		none_ls.builtins.formatting.golines,
		none_ls.builtins.code_actions.gomodifytags,
		none_ls.builtins.code_actions.impl,
		-- none_ls.builtins.code_actions.iferr,
		-- Terraform
		none_ls.builtins.formatting.terraform_fmt,
		-- none_ls.builtins.diagnostics.terraform_validate,
		none_ls.builtins.diagnostics.tfsec,
		none_ls.builtins.diagnostics.trivy,
		-- Godot
		none_ls.builtins.diagnostics.gdlint.with({
			filetypes = { "gd", "gdscript", "gdscript3" },
		}),
		none_ls.builtins.formatting.gdformat,
		-- Others
		none_ls.builtins.formatting.stylua,
		none_ls.builtins.diagnostics.hadolint,
		none_ls.builtins.diagnostics.actionlint.with({
			runtime_condition = function(params)
				return params.bufname:find(vim.pesc(".github/workflows")) ~= nil
			end,
		}),
		none_ls.builtins.formatting.yamlfmt,
		none_ls.builtins.diagnostics.yamllint.with({
			extra_args = { "-c", vim.fn.expand("~/.config/yamllint/config") },
			disabled_filetypes = { "helm" },
		}),
		none_ls.builtins.formatting.shfmt,
		none_ls.builtins.formatting.prettier.with({ filetypes = { "astro" } }),
		none_ls.builtins.formatting.rustywind, -- TailwindCSS
	},
	on_attach = function(client, bufnr)
		-- Only attach to clients that support document formatting
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({
				group = get_augroup(client),
				buffer = bufnr,
			})
			-- Create an autocmd that will run *before* we save the buffer.
			--  Run the formatting command for the tool that has just attached.
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = get_augroup(client),
				buffer = bufnr,
				callback = function()
					if not format_is_enabled then
						return
					end
					--  Run the formatting command for the tool that has just attached.
					vim.lsp.buf.format({ bufnr = bufnr })
				end,
			})
		end
	end,
}

none_ls.setup(opts)

-- HCLFMT on save
vim.api.nvim_create_autocmd("BufWritePost", {
	group = vim.api.nvim_create_augroup("terragrunt-hclfmt", { clear = true }),
	callback = function()
		if not format_is_enabled then
			return
		end
		if vim.bo.filetype == "hcl" then
			vim.cmd("silent !terragrunt hclfmt --terragrunt-hclfmt-file %")
		end
	end,
})
