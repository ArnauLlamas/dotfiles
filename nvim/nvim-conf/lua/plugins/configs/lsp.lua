local servers = {
	"lua_ls",
	"stylua",
	"terraformls",
	"tflint",
	"helm_ls",
	"yamlls",
	"jsonls",
	"gh_actions_ls",
	"dockerls",
	"bashls",
	"astro",
	"html",
	"cssls",
	"pylsp",
	"pyright",
	"ruff",
}

local tools = {
	"actionlint",
	"black",
	"hadolint",
	"shellcheck",
	"shfmt",
	"trivy",
	"tfsec",
	"yamlfmt",
	"yamllint",
	"prettier",
	"rustywind",
	"gofumpt",
	"goimports-reviser",
	"golines",
	"gomodifytags",
	"delve",
	"iferr",
	"impl",
	"debugpy",
	"selene",
}

vim.api.nvim_create_user_command("MasonInstallTools", function()
	vim.cmd("MasonInstall " .. table.concat(tools, " "))
end, {})

require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = servers,
	automatic_installation = true,
})

require("plugins.configs.none-ls")

vim.lsp.config("terraformls", {
	filetypes = { "terraform", "terraform-vars", "hcl" },
})

-- Configure servers not available in mason_lspconfig
vim.lsp.enable("gdscript")

-- Configure local LSP if exists
local testing_lsp = "terragrunt-ls"
if vim.fn.isdirectory(vim.fn.expand("$PERSONAL") .. "/" .. testing_lsp) == 1 then
	vim.lsp.config(testing_lsp, {
		filetypes = { "hcl" },
		capabilities = require("blink.cmp").get_lsp_capabilities(nil, true),
		cmd = { vim.fn.expand("$PERSONAL") .. "/" .. testing_lsp .. "/" .. testing_lsp, "serve" },
		root_markers = { ".git" },
	})

	vim.lsp.enable(testing_lsp)
end

local nmap = function(keys, func, desc)
	if desc then
		desc = "LSP: " .. desc
	end

	vim.keymap.set("n", keys, func, { desc = desc })
end

nmap("<leader>lr", vim.lsp.buf.rename, "[L]sp [R]ename")
nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

-- See `:help K` for why this keymap
nmap("K", vim.lsp.buf.hover, "Hover Documentation")
nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

-- Lesser used LSP functionality
nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

-- Create a command `:LspFormat` local to the LSP buffer
vim.api.nvim_buf_create_user_command(vim.api.nvim_get_current_buf(), "LspFormat", function(_)
	vim.lsp.buf.format()
end, { desc = "Format current buffer with LSP" })
--
vim.keymap.set("n", "<leader>lf", "<cmd>LspFormat<CR>", { desc = "[L]sp [F]ormat" })
vim.keymap.set(
	"n",
	"<leader>lF",
	"<cmd>LspFormat<CR><cmd>FormattingDisable<CR><cmd>write<CR><cmd>FormattingEnable<CR>",
	{ desc = "[L]sp [F]ormat and save" }
)

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>dd", function()
	vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Go to next diagnostic message" })

vim.keymap.set("n", "<leader>dn", function()
	vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Go to next diagnostic message" })

vim.keymap.set("n", "<leader>dp", function()
	vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Go to previous diagnostic message" })

vim.keymap.set("n", "<leader>dt", vim.diagnostic.open_float, { desc = "Toggle floating diagnostic message" })
