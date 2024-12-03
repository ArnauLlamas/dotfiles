vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.have_nerd_font = true

-- Set neovim's language to English
local sys = vim.api.nvim_exec2("!uname", { output = true }).output
if string.find(sys, "Linux") then
	vim.api.nvim_exec2("language en_US.utf-8", {})
elseif string.find(sys, "Darwin") then
	vim.api.nvim_exec2("language en_US", {})
end

-- Make underscores a word separator
vim.opt.iskeyword:remove({ "_" })

-- Enable spellcheck
vim.opt.spell = true

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

-- [[ Highlight on yank ]]
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})

-- autodetect helm files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = {
		"*/templates/*.yaml",
		"*/templates/*.yml",
		"*/templates/*.tpl",
		"*.gotmpl",
		"helmfile*.yaml",
		"helmfile*.yml",
	},
	callback = function()
		vim.cmd("setfiletype helm")
	end,
})

-- autodetect justfiles
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = {
		"justfile",
	},
	callback = function()
		vim.cmd("setfiletype just")
	end,
})

-- autodetect gdscript files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = {
		"**/*.gd",
		"*.gd",
	},
	callback = function()
		vim.cmd("setfiletype gdscript")
	end,
})
