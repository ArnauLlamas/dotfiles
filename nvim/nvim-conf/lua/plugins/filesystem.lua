return {
	{
		-- Filesystem
		"stevearc/oil.nvim",
		opts = {},
		-- Optional dependencies
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("oil").setup({
				default_file_explorer = true,
				skip_confirm_for_simple_edits = true,
				view_options = {
					show_hidden = true,
					natural_order = true,
				},
			})
			vim.keymap.set("n", "<leader>_", "<cmd>Oil<CR>", { desc = "Open Oil" })
		end,
	},
}
