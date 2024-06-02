return {
	{
		-- LSP Configuration & Plugins
		"neovim/nvim-lspconfig",
		dependencies = {
			-- Automatically install LSPs to stdpath for neovim
			{
				"williamboman/mason.nvim",
				config = function()
					return require("plugins.configs.mason")
				end,
			},
			"williamboman/mason-lspconfig.nvim",

			-- Useful status updates for LSP
			-- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
			{
				"j-hui/fidget.nvim",
				config = function()
					require("fidget").setup({
						notification = {
							window = {
								winblend = 0,
							},
						},
					})
				end,
			},

			-- Additional lua configuration, makes nvim stuff amazing!
			-- { "folke/neodev.nvim", opts = {} },
			{ "folke/lazydev.nvim", opts = {} },
		},
		config = function()
			require("plugins.configs.lspconfig")
		end,
	},
	{
		"nvimtools/none-ls.nvim",
		-- ft = { "python", "go", "terraform", "hcl", "yaml", "lua" },
		opts = function()
			return require("plugins.configs.none-ls")
		end,
	},
}
