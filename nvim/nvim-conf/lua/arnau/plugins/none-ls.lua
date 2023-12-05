return {
	"nvimtools/none-ls.nvim",
	-- ft = { "python", "go", "terraform", "hcl", "yaml", "lua" },
	opts = function()
		return require("arnau.plugins.configs.none-ls")
	end,
}
