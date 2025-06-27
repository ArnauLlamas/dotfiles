return {
	{
		"saghen/blink.cmp",
		dependencies = {
			"rafamadriz/friendly-snippets",
			"giuxtaposition/blink-cmp-copilot",
			-- "fang2hou/blink-copilot",
			"mgalliou/blink-cmp-tmux",
			"mikavilpas/blink-ripgrep.nvim",
		},

		version = "1.*",

		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			keymap = {
				preset = "default",
			},
			sources = {
				default = { "lsp", "path", "snippets", "buffer", "tmux", "ripgrep", "copilot" },
				providers = {
					tmux = {
						module = "blink-cmp-tmux",
						name = "tmux",
						-- default options
						opts = {
							all_panes = false,
							capture_history = false,
							-- only suggest completions from `tmux` if the `trigger_chars` are used
							triggered_only = true,
							trigger_chars = { ":" },
						},
						transform_items = function(_, items)
							for _, item in ipairs(items) do
								-- example: append a description to easily distinguish tmux results
								item.labelDetails = {
									description = "(tx)",
								}
							end
							return items
						end,
					},
					ripgrep = {
						module = "blink-ripgrep",
						name = "Ripgrep",
						score_offset = -20,
						-- (optional) customize how the results are displayed. Many options
						-- are available - make sure your lua LSP is set up so you get
						-- autocompletion help
						transform_items = function(_, items)
							for _, item in ipairs(items) do
								-- example: append a description to easily distinguish rg results
								item.labelDetails = {
									description = "(rg)",
								}
							end
							return items
						end,
					},
					copilot = {
						name = "copilot",
						module = "blink-cmp-copilot",
						score_offset = 5,
						async = true,
						transform_items = function(_, items)
							local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
							local kind_idx = #CompletionItemKind + 1
							CompletionItemKind[kind_idx] = "Copilot"
							for _, item in ipairs(items) do
								item.kind = kind_idx
							end
							return items
						end,
					},
				},
			},
			appearance = {
				highlight_ns = vim.api.nvim_create_namespace("blink_cmp"),
				use_nvim_cmp_as_default = false,
				nerd_font_variant = "mono",

				-- kind_icons = {
				-- 	Copilot = "",
				-- 	Text = "󰉿",
				-- 	Method = "󰊕",
				-- 	Function = "󰊕",
				-- 	Constructor = "󰒓",
				--
				-- 	Field = "󰜢",
				-- 	Variable = "󰆦",
				-- 	Property = "󰖷",
				--
				-- 	Class = "󱡠",
				-- 	Interface = "󱡠",
				-- 	Struct = "󱡠",
				-- 	Module = "󰅩",
				--
				-- 	Unit = "󰪚",
				-- 	Value = "󰦨",
				-- 	Enum = "󰦨",
				-- 	EnumMember = "󰦨",
				--
				-- 	Keyword = "󰻾",
				-- 	Constant = "󰏿",
				--
				-- 	Snippet = "󱄽",
				-- 	Color = "󰏘",
				-- 	File = "󰈔",
				-- 	Reference = "󰬲",
				-- 	Folder = "󰉋",
				-- 	Event = "󱐋",
				-- 	Operator = "󰪚",
				-- 	TypeParameter = "󰬛",
				-- },
			},
			signature = { enabled = true },
			completion = { documentation = { auto_show = true } },
			fuzzy = { implementation = "prefer_rust_with_warning" },
		},
		opts_extend = { "sources.default" },
	},
}
