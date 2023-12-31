return {
	{
		"tpope/vim-fugitive",
		config = function()
			vim.keymap.set("n", "<leader>git", "<cmd>Git<CR>")
		end,
	},
	"tpope/vim-rhubarb",
	-- Adds git related signs to the gutter, as well as utilities for managing changes
	{
		"lewis6991/gitsigns.nvim",
		opts = require("plugins.configs.gitsigns"),
	},
}
