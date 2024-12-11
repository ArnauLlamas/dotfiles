return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
		},
		"nvim-telescope/telescope-ui-select.nvim",
	},
	config = function()
		-- For some reason I cannot make this work with opts :/
		require("telescope").setup({
			-- See `:help telescope` and `:help telescope.setup()`
			extensions = {
				fzf = {},
			},
			defaults = vim.tbl_extend("force", require("telescope.themes").get_ivy(), {
				path_display = {
					truncate = 2,
				},
			}),
		})
		local builtin = require("telescope.builtin")
		local utils = require("telescope.utils")
		local multigrep = require("plugins.configs.telescope.multigrep")
		local function nmap(keymap, func, desc)
			vim.keymap.set("n", keymap, func, { desc = desc })
		end

		nmap("<leader>f/", function()
			builtin.live_grep({ grep_open_files = true, prompt_title = "Live Grep in Open Files" })
		end, "[F]ind [/] in Open Files")
		nmap("<leader>?", builtin.oldfiles, "[?] Find recently opened files")
		nmap("<leader><space>", builtin.buffers, "[ ] Find existing buffers")
		nmap("<leader>fc", builtin.current_buffer_fuzzy_find, "[F]ind in [C]urrent buffer")
		nmap("<leader>ff", function()
			builtin.find_files({ cwd = utils.buffer_dir() })
		end, "[F]ind [F]iles")
		nmap("<leader>fF", builtin.git_files, "[F]ind [F]iles from git root")
		nmap("<leader>fb", builtin.builtin, "[F]ind Telescope [B]uiltins")
		nmap("<leader>fh", builtin.help_tags, "[F]ind [H]elp [T]ags")
		nmap("<leader>fw", builtin.grep_string, "[F]ind current [W]ord")
		nmap("<leader>fg", function()
			multigrep.live_multigrep({ cwd = utils.buffer_dir() })
		end, "[F]ind [G]rep")
		nmap("<leader>fG", function()
			multigrep.live_multigrep({ cwd = vim.fn.systemlist("git rev-parse --show-toplevel")[1] })
		end, "[F]ind [G]rep from git root")

		-- LSP specifics
		nmap("<leader>ft", builtin.treesitter, "[F]ind [T]reesitter symbols")
		nmap("<leader>fd", function()
			builtin.diagnostics({ bufnr = 0 })
		end, "[F]ind LSP [D]iagnostics")
		nmap("<leader>fD", builtin.diagnostics, "[F]ind LSP [D]iagnostics all workspace")
		nmap("gd", builtin.lsp_definitions, "LSP: [G]oto [D]efinition")
		nmap("gr", builtin.lsp_references, "LSP: [G]oto [R]eferences")
		nmap("gI", builtin.lsp_implementations, "LSP: [G]oto [I]mplementation")
		nmap("gD", builtin.lsp_type_definitions, "LSP: [G]oto type [D]efinition")
		nmap("<leader>fs", builtin.lsp_document_symbols, "LSP: [F]ind [S]ymbols")
		nmap("<leader>fS", builtin.lsp_dynamic_workspace_symbols, "LSP: [F]ind [S]ymbols all workspace")

		-- Niche finders
		nmap("<leader>fp", function()
			require("telescope.builtin").find_files({
				cwd = vim.fn.stdpath("data") .. "/" .. "lazy",
			})
		end, "[F]ind Neovim [P]ackages")
	end,
}
