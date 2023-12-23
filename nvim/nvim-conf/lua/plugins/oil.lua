return {
	"stevearc/oil.nvim",
	opts = {
		default_file_explorer = false,
		skip_confirm_for_simple_edits = true,
		view_options = {
			show_hidden = true,
		},
	},
	-- Optional dependencies
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function(opts)
		require("oil").setup(opts)
		vim.keymap.set("n", "<leader>_", "<cmd>Oil<CR>", { desc = "Open Oil" })
	end,
}
