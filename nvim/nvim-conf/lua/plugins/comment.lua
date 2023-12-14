return {
	-- "gc" to comment visual regions/lines
	"numToStr/Comment.nvim",
	opts = {},
	-- If any day this PR is merged delete this custom config block
	-- https://github.com/numToStr/Comment.nvim/pull/398
	config = function()
		local ft = require("Comment.ft")
		ft.hcl = { "#%s", "/*%s*/" }
	end,
}
