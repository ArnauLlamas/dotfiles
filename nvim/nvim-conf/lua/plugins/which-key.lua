return {
	-- Useful plugin to show you pending keybinds.
	"folke/which-key.nvim",
	opts = {},
	config = function()
		-- document existing key chains
		require("which-key").add({
			{ "<leader>c", group = "[C]ode" },
			{ "<leader>d", group = "[D]ocument" },
			{ "<leader>g", group = "[G]it" },
			{ "<leader>h", group = "Git [H]unk" },
			{ "<leader>f", group = "[F]ind" },
			{ "<leader>t", group = "[T]oggle" },
			{ "<leader>w", group = "[W]orkspace" },
			{ "<leader>l", group = "[L]SP" },
			{ "<leader>s", group = "[S]plit" },
			{ "<leader>x", group = "Trouble" },
		})
		-- register which-key VISUAL mode
		-- required for visual <leader>hs (hunk stage) to work
		require("which-key").add({
			{ "<leader>", group = "VISUAL <leader>", mode = "v" },
			{ "<leader>h", desc = "Git [H]unk", mode = "v" },
		})
	end,
}
