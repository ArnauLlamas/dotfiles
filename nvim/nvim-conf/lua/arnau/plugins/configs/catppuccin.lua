require("catppuccin").setup({
	transparent_background = false,
	styles = {
		comments = {},
	},
	integrations = {
		mason = true,
		which_key = true,
		treesitter_context = true,
		gitsigns = true,
		fidget = true,
		indent_blankline = {
			enabled = true,
			scope_color = "lavender",
			colored_indent_levels = false,
		},
		lsp_trouble = true,
	},
})

-- load colorscheme here
vim.cmd.colorscheme("catppuccin-mocha")
