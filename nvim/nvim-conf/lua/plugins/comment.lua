return {
	-- "gc" to comment visual regions/lines
	"numToStr/Comment.nvim",
	lazy = false,
	config = function()
		local ft = require("Comment.ft")
		ft.helm = { "{{- /*%s*/ }}" }
		ft.zsh = { "#%s" }
		require("Comment").setup({
			pre_hook = function()
				if vim.bo.filetype == "zsh" then
					return "#%s"
				end
			end,
		})
	end,
}
