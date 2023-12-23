return {
	"folke/trouble.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("trouble").setup()
		vim.keymap.set("n", "<leader>q", "<cmd>TroubleToggle<CR>", { desc = "Open trouble list" })
	end,
}
