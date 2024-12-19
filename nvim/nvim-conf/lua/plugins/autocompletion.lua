return {
	{
		"saghen/blink.cmp",
		dependencies = {
			"rafamadriz/friendly-snippets",
			"giuxtaposition/blink-cmp-copilot",
		},

		version = "v0.*",

		opts = {
			keymap = {
				preset = "default",
				-- keymap = { ["<CR>"] = { "select_and_accetp", "fallback" } },
			},

			sources = {
				providers = {
					copilot = {
						name = "copilot",
						module = "blink-cmp-copilot",
						score_offset = 100,
						async = true,
					},
				},
			},

			completion = {
				enabled_sources = { "lsp", "path", "snippets", "buffer", "copilot" },
			},

			appearance = {
				use_nvim_cmp_as_default = true,
				nerd_font_variant = "mono",
			},

			signature = { enabled = true },
			-- accept = { auto_brackets = { enabled = true } },
			documentation = { auto_show = true },
		},
	},
}
