--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
	-- In this case, we create a function that lets us more easily define mappings specific
	-- for LSP related items. It sets the mode, buffer and description for us each time.
	local nmap = function(keys, func, desc)
		if desc then
			desc = "LSP: " .. desc
		end

		vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
	end

	nmap("<leader>lr", vim.lsp.buf.rename, "[L]sp [R]ename")
	nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

	nmap("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
	nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
	nmap("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
	nmap("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
	nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
	nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

	-- See `:help K` for why this keymap
	nmap("K", vim.lsp.buf.hover, "Hover Documentation")
	nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

	-- Lesser used LSP functionality
	nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

	-- Create a command `:LspFormat` local to the LSP buffer
	vim.api.nvim_buf_create_user_command(bufnr, "LspFormat", function(_)
		vim.lsp.buf.format()
	end, { desc = "Format current buffer with LSP" })

	vim.keymap.set("n", "<leader>lf", "<cmd>LspFormat<CR>", { desc = "[L]sp [F]ormat" })

	-- Diagnostic keymaps
	vim.keymap.set("n", "<leader>dd", vim.diagnostic.goto_next)
	vim.keymap.set("n", "<leader>dn", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
	vim.keymap.set("n", "<leader>dp", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
	vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
end

-- mason-lspconfig requires that these setup functions are called in this order
-- before setting up the servers.
require("mason").setup()
require("mason-lspconfig").setup()

-- Enable the following language servers
local servers = {
	pyright = {},
	docker_compose_language_service = {},
	html = {},
	cssls = {},
	yamlls = {},
	jsonls = {},
	dockerls = {},
	bashls = {},
	tailwindcss = {},
	templ = {},
	helm_ls = {
		yamlls = {
			path = "yaml-language-server",
		},
	},

	gopls = {
		filetypes = { "go", "gomod", "gowork", "gotmpl" },
		gopls = {
			completeUnimported = true,
			usePlaceholders = true,
			analyses = {
				unusedparams = true,
			},
			gofumpt = true,
		},
	},

	terraformls = {
		filetypes = { "terraform", "terraform-vars" },
		-- Terraform LS uses stderr for everything
		-- https://github.com/hashicorp/terraform-ls/issues/1271
		cmd = { "terraform-ls", "serve", "-log-file", "/dev/null" },
	},
	tflint = {
		filetypes = { "terraform", "terraform-vars" },
	},

	ts_ls = {
		init_options = {
			preferences = {
				disableSuggestions = true,
			},
		},
	},
	volar = {},
	astro = {},

	lua_ls = {
		Lua = {
			workspace = { checkThirdParty = false },
			telemetry = { enable = false },
			-- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
			diagnostics = { disable = { "missing-fields" } },
		},
	},
}

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require("mason-lspconfig")

mason_lspconfig.setup({
	ensure_installed = vim.tbl_keys(servers),
})

mason_lspconfig.setup_handlers({
	function(server_name)
		require("lspconfig")[server_name].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			settings = servers[server_name],
			filetypes = (servers[server_name] or {}).filetypes,
		})
	end,
})

-- Configure servers not available in mason_lspconfig
local lspconfig = require("lspconfig")
lspconfig.gdscript.setup({})

-- Configure local LSP if exists
local testing_lsp = "terragrunt-ls"
if vim.fn.isdirectory(vim.fn.expand("$PERSONAL") .. "/" .. testing_lsp) == 1 then
	local lsp = require("lspconfig")
	local configs = require("lspconfig.configs")

	configs.testing_lsp = {
		default_config = {
			name = testing_lsp,
			cmd = { vim.fn.expand("$PERSONAL") .. "/" .. testing_lsp .. "/" .. testing_lsp, "serve" },
			-- cmd = { vim.fn.expand("$PERSONAL") .. "/" .. testing_lsp .. "/server.sh" },
			filetypes = { "hcl" },
			root_dir = function()
				return vim.fn.getcwd()
			end,
		},
	}

	lsp.testing_lsp.setup({
		capabilities = capabilities,
		on_attach = on_attach,
	})
end
