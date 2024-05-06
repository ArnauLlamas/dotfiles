return {
	signs = {
		add = { text = "+" },
		change = { text = "~" },
		delete = { text = "_" },
		topdelete = { text = "‾" },
		changedelete = { text = "~" },
		untracked = { text = "┆" },
	},
	on_attach = function(bufnr)
		local gs = package.loaded.gitsigns

		-- Navigation
		vim.keymap.set({ "n", "v" }, "]c", function()
			if vim.wo.diff then
				return "]c"
			end
			vim.schedule(function()
				gs.next_hunk()
			end)
			return "<Ignore>"
		end, { expr = true, buffer = bufnr, desc = "Jump to next hunk" })
		vim.keymap.set({ "n", "v" }, "[c", function()
			if vim.wo.diff then
				return "[c"
			end
			vim.schedule(function()
				gs.prev_hunk()
			end)
			return "<Ignore>"
		end, { expr = true, buffer = bufnr, desc = "Jump to previous hunk" })

		-- Actions
		-- Visual mode
		vim.keymap.set("v", "<leader>hs", function()
			gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, { desc = "Stage git hunk" })
		vim.keymap.set("v", "<leader>hr", function()
			gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, { desc = "Reset git hunk" })
		-- Normal mode
		vim.keymap.set("n", "<leader>hs", gs.stage_hunk, { desc = "Git stage hunk" })
		vim.keymap.set("n", "<leader>hr", gs.reset_hunk, { desc = "Git reset hunk" })
		vim.keymap.set("n", "<leader>hS", gs.stage_buffer, { desc = "Git Stage buffer" })
		vim.keymap.set("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
		vim.keymap.set("n", "<leader>hR", gs.reset_buffer, { desc = "Git Reset buffer" })
		vim.keymap.set("n", "<leader>hp", gs.preview_hunk, { desc = "Preview git hunk" })
		vim.keymap.set("n", "<leader>hb", function()
			gs.blame_line({ full = false })
		end, { desc = "Git blame line" })
		vim.keymap.set("n", "<leader>hd", gs.diffthis, { desc = "Git diff against index" })
		vim.keymap.set("n", "<leader>hD", function()
			gs.diffthis("~")
		end, { desc = "Git diff against last commit" })

		-- Toggles
		vim.keymap.set("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "Toggle git blame line" })
		vim.keymap.set("n", "<leader>td", gs.toggle_deleted, { desc = "Toggle git show deleted" })

		-- Text object
		vim.keymap.set({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select git hunk" })
	end,
}
