return {
	-- "gc" to comment visual regions/lines
	"numToStr/Comment.nvim",
	opts = {},
	lazy = false,
	config = function()
		local ft = require("Comment.ft")
		ft.helm = { "{{- /*%s*/ }}" }
		require("Comment").setup()
	end,
}
