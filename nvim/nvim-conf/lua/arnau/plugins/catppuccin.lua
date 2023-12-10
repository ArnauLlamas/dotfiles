return {
	"catppuccin/nvim",
	lazy = false,
	name = "catppuccin",
	priority = 1000,
	config = function()
		return require("arnau.plugins.configs.catppuccin")
	end,
}
