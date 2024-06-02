return {
	{ "towolf/vim-helm" },
	{ "ttibsi/pre-commit.nvim" },
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		---@type Flash.Config
		opts = {},
		-- stylua: ignore
		keys = {
			{ "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
			{ "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
			{ "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
			{ "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
			{ "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
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
