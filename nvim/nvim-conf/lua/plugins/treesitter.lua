return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	dependencies = {
		{ "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
	},
	build = ":TSUpdate",
	config = function()
		require("plugins.configs.treesitter")
	end,
}
