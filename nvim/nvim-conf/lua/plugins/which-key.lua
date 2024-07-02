return {
	-- Useful plugin to show you pending keybinds.
	"folke/which-key.nvim",
	opts = {},
	config = function()
		-- document existing key chains
		require("which-key").register({
			["<leader>c"] = { name = "[C]ode", _ = "which_key_ignore" },
			["<leader>d"] = { name = "[D]ocument", _ = "which_key_ignore" },
			["<leader>g"] = { name = "[G]it", _ = "which_key_ignore" },
			["<leader>h"] = { name = "Git [H]unk", _ = "which_key_ignore" },
			["<leader>f"] = { name = "[F]ind", _ = "which_key_ignore" },
			["<leader>t"] = { name = "[T]oggle", _ = "which_key_ignore" },
			["<leader>w"] = { name = "[W]orkspace", _ = "which_key_ignore" },
			["<leader>l"] = { name = "[L]SP", _ = "which_key_ignore" },
			["<leader>s"] = { name = "[S]plit", _ = "which_key_ignore" },
			["<leader>x"] = { name = "Trouble", _ = "which_key_ignore" },
		})
		-- register which-key VISUAL mode
		-- required for visual <leader>hs (hunk stage) to work
		require("which-key").register({
			["<leader>"] = { name = "VISUAL <leader>" },
			["<leader>h"] = { "Git [H]unk" },
		}, { mode = "v" })
	end,
}
