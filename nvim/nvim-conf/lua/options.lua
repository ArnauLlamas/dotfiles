vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("remap")

-- Set highlight on search
vim.o.hlsearch = false
vim.opt.incsearch = true

-- Make relative line numbers default
vim.wo.number = true
vim.opt.relativenumber = true

-- Enable mouse mode
vim.o.mouse = "a"

-- Sync clipboard between OS and Neovim.
vim.o.clipboard = "unnamedplus"

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = "yes"

-- Decrease update time
vim.o.updatetime = 50
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

vim.o.termguicolors = true

vim.opt.colorcolumn = "80,100,120"

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.splitbelow = true
vim.opt.splitright = true

-- Do not show indent lines on dashboard
vim.g.indent_blankline_filetype_exclude = { "dashboard" }

-- HCLFMT on save
vim.api.nvim_create_autocmd("BufWritePost", {
	group = vim.api.nvim_create_augroup("terragrunt-hclfmt", { clear = true }),
	callback = function()
		if not FORMAT_IS_ENABLED then
			return
		end
		if vim.bo.filetype == "hcl" then
			vim.cmd("silent !sh terragrunt hclfmt --terragrunt-hclfmt-file %")
		end
	end,
})

-- Toggle transparent background
vim.api.nvim_create_user_command("BackgroundToggle", function()
	local cat = require("catppuccin")
	cat.options.transparent_background = not cat.options.transparent_background
	cat.compile()
	vim.cmd.colorscheme(vim.g.colors_name)
end, {})
vim.keymap.set("n", "<leader>tt", "<cmd>BackgroundToggle<CR>", { desc = "Background [T]oggle [T]ransparency" })

-- [[ Highlight on yank ]]
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})
