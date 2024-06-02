return {
	-- "gc" to comment visual regions/lines
	"numToStr/Comment.nvim",
	opts = {},
	lazy = false,
	-- If any day this PR is merged delete this custom config block
	-- https://github.com/numToStr/Comment.nvim/pull/398
	config = function()
		local ft = require("Comment.ft")
		ft.hcl = { "#%s", "/*%s*/" }
		ft.helm = { "{{- /*%s*/ }}" }
		require("Comment").setup()
		-- 	-- Toggle comment
		-- 	vim.keymap.set("n", "<leader>/", function()
		-- 		require("Comment.api").toggle.linewise.current()
		-- 	end, { desc = "Toggle comment" })
		-- 	vim.keymap.set(
		-- 		"v",
		-- 		"<leader>/",
		-- 		"<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
		-- 		{ desc = "Toggle comment" }
		-- )
	end,
}
