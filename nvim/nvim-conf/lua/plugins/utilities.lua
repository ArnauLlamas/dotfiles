return {
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			lsp = {
				-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
				},
			},
			presets = {
				bottom_search = true,     -- use a classic bottom cmdline for search
				command_palette = false,  -- position the cmdline and popupmenu together
				long_message_to_split = true, -- long messages will be sent to a split
				inc_rename = false,       -- enables an input dialog for inc-rename.nvim
				lsp_doc_border = false,   -- add a border to hover docs and signature help
			},
		},
		dependencies = {
			"MunifTanjim/nui.nvim",
			"hrsh7th/nvim-cmp",
			"rcarriga/nvim-notify",
		},
	},
	-- Detect tabstop and shiftwidth automatically
	"tpope/vim-sleuth",
	{
		"szw/vim-maximizer",
		config = function()
			vim.keymap.set("n", "<leader>mx", "<cmd>MaximizerToggle<CR>", { desc = "[M]a[x]imize current buffer" })
		end,
	},
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
		config = function()
			vim.keymap.set("n", "<leader>md", "<cmd>MarkdownPreviewToggle<CR>", { desc = "[M]ark[D]own preview" })
		end,
	},
	{
		"David-Kunz/gen.nvim",
		opts = {
			model = "codellama",
			show_promtp = true,
			show_model = true,
		},
		config = function(opts)
			require("gen").setup(opts)

			require("gen").prompts["DevOps Me!"] = {
				prompt =
				"You are a senior devops engineer, acting as an assistant. You offer help with cloud technologies like: Terraform, terragrunt, AWS, kubernetes. You answer with code examples when possible. $input:\n$text",
				replace = true,
			}
			require("gen").prompts["Pair Programmer"] = {
				prompt =
				"You are a senior software developer, acting as an assistant. You offer help with software web technologies and frameworks like: javascript, typescript, astro, go, python, lua. You answer with code examples when possible. $input:\n$text",
				replace = true,
			}

			vim.keymap.set({ "n", "v" }, "<leader>AG", "<cmd>Gen<CR>")

			vim.keymap.set({ "n", "v" }, "<leader>Ado", "<cmd>Gen DevOps Me!<CR>")
			vim.keymap.set({ "n", "v" }, "<leader>App", "<cmd>Gen Pair Programmer<CR>")
		end,
	},
}
