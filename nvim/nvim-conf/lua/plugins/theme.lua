return {
	{
		"catppuccin/nvim",
		lazy = false,
		name = "catppuccin",
		priority = 1000,
		config = function()
			return require("plugins.configs.catppuccin")
		end,
	},
	{
		-- Add indentation guides even on blank lines
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {
			exclude = {
				filetypes = { "dashboard" },
				buftypes = { "terminal" },
			},
		},
	},
	{
		"nvim-lualine/lualine.nvim",
		-- See `:help lualine.txt`
		opts = {
			options = {
				icons_enabled = true,
				theme = "catppuccin",
				component_separators = { left = "|", right = "<" },
				section_separators = { left = "", right = "" },
			},
		},
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"hrsh7th/nvim-cmp",
			"rcarriga/nvim-notify",
		},
		config = function()
			require("notify").setup({
				timeout = 1500,
				stages = "static",
			})

			require("noice").setup({
				routes = {
					{
						filter = {
							event = "msg_show",
							kind = "",
							find = "written",
						},
						opts = { skip = true },
					},
				},
				views = {
					cmdline_popup = {
						border = {
							style = "none",
							padding = { 1, 3 },
						},
						filter_options = {},
						win_options = {
							winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
						},
					},
				},
				lsp = {
					-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
						["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
					},
				},
				presets = {
					bottom_search = true, -- use a classic bottom cmdline for search
					command_palette = false, -- position the cmdline and popupmenu together
					long_message_to_split = true, -- long messages will be sent to a split
					inc_rename = false, -- enables an input dialog for inc-rename.nvim
					lsp_doc_border = false, -- add a border to hover docs and signature help
				},
			})
		end,
	},
	{
		"nvimdev/dashboard-nvim",
		event = "VimEnter",
		config = function()
			require("plugins.configs.dashboard")
		end,
	},
}
