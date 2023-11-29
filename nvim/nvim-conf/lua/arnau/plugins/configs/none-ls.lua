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
-- local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local none_ls = require("null-ls")

local opts = {
	sources = {
		-- Python
		none_ls.builtins.formatting.black,
		none_ls.builtins.diagnostics.mypy,
		none_ls.builtins.diagnostics.ruff,
		-- Go
		none_ls.builtins.formatting.gofumpt,
		none_ls.builtins.formatting.goimports_reviser,
		none_ls.builtins.formatting.golines,
		-- Terraform
		none_ls.builtins.formatting.terraform_fmt,
		none_ls.builtins.formatting.hclfmt,
		none_ls.builtins.diagnostics.terraform_validate,
		none_ls.builtins.diagnostics.tfsec,
		none_ls.builtins.diagnostics.trivy,
		-- Others
		none_ls.builtins.formatting.stylua,
		none_ls.builtins.diagnostics.hadolint,
		none_ls.builtins.diagnostics.actionlint,
		none_ls.builtins.formatting.yamlfix,
		none_ls.builtins.diagnostics.yamllint,
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
					--  Run the formatting command for the tool that has just attached.
					vim.lsp.buf.format({ bufnr = bufnr })
				end,
			})
		end
	end,
}

none_ls.setup(opts)
