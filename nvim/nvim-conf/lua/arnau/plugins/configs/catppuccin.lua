require("catppuccin").setup({
	transparent_background = true,
	styles = {
		comments = {},
	},
	integrations = {
		telescope = {
			enabled = true,
			style = "nvchad",
		},
		mason = true,
		which_key = true,
		cmp = true,
		treesitter = true,
		treesitter_context = true,
		gitsigns = true,
		fidget = true,
		markdown = true,
		dap = {
			enabled = true,
			enable_ui = true,
		},
		lsp_trouble = true,
		native_lsp = {
			enabled = true,
			virtual_text = {
				errors = { "italic" },
				hints = { "italic" },
				warnings = { "italic" },
				information = { "italic" },
			},
			underlines = {
				errors = { "underline" },
				hints = { "underline" },
				warnings = { "underline" },
				information = { "underline" },
			},
			inlay_hints = {
				background = true,
			},
		},
		indent_blankline = {
			enabled = true,
			scope_color = "lavender",
			colored_indent_levels = false,
		},
	},
})

-- load colorscheme here
vim.cmd.colorscheme("catppuccin-mocha")
