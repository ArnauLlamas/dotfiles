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
		flash = true,
		indent_blankline = {
			enabled = true,
			scope_color = "lavender",
			colored_indent_levels = false,
		},
		lsp_trouble = true,
		noice = true,
	},
})

-- Toggle transparent background
vim.api.nvim_create_user_command("BackgroundToggle", function()
	local cat = require("catppuccin")
	cat.options.transparent_background = not cat.options.transparent_background
	cat.compile()
	vim.cmd.colorscheme(vim.g.colors_name)
end, {})
vim.keymap.set("n", "<leader>tt", "<cmd>BackgroundToggle<CR>", { desc = "Background [T]oggle [T]ransparency" })

-- load colorscheme here
vim.cmd.colorscheme("catppuccin-mocha")
