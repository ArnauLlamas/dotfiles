vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- select and move around
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Keep cursor at the beginning of line when joining
vim.keymap.set("n", "J", "mzJ`z")

-- Keep cursor in the middle for some movements
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Do not add to clipboard deleted things when pasting
vim.keymap.set("x", "p", '"_dP')

-- Find and replace
vim.keymap.set(
	"n",
	"<leader>r",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ desc = "Find and [R]eplace" }
)

-- Move around buffers
vim.keymap.set("n", "<leader>n", "<cmd>bn<CR>", { desc = "Buffer [N]ext" })
vim.keymap.set("n", "<leader>p", "<cmd>bp<CR>", { desc = "Buffer [P]revious" })
vim.keymap.set("n", "<leader>q", "<cmd>b#|bd#<CR>", { desc = "Buffer Close File" })
vim.keymap.set("n", "<leader>Q", "<cmd>bd<CR>", { desc = "Buffer Delete" })

vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })
vim.keymap.set("n", "<Tab>", "<cmd>wincmd w<CR>", { desc = "Move to next buffer" })
vim.keymap.set("n", "<S-Tab>", "<cmd>wincmd W<CR>", { desc = "Move to previous buffer" })

vim.keymap.set("n", "<leader>ss", "<cmd>vertical split<CR>", { desc = "[S]plit" })
vim.keymap.set("n", "<leader>sv", "<cmd>vertical split<CR>", { desc = "[S]plit [V]ertical" })
vim.keymap.set("n", "<leader>sh", "<cmd>horizontal new<CR>", { desc = "[S]plit [H]orizontal" })
vim.keymap.set("i", "jj", "<ESC>")

-- Tabbing in visual mode with Tab
vim.keymap.set("v", "<Tab>", ">gv")
vim.keymap.set("v", "<S-Tab>", "<gv")
