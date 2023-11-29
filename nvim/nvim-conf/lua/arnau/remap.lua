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

-- Toggle comment
vim.keymap.set("n", "<leader>/", function()
	require("Comment.api").toggle.linewise.current()
end, { desc = "Toggle comment" })
vim.keymap.set(
	"v",
	"<leader>/",
	"<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
	{ desc = "Toggle comment" }
)

-- Move around buffers
vim.keymap.set("n", "<leader>n", "<cmd>bn<CR>", { desc = "Buffer [N]ext" })
vim.keymap.set("n", "<leader>p", "<cmd>bp<CR>", { desc = "Buffer [P]revious" })
vim.keymap.set("n", "<leader>x", "<cmd>bd<CR>", { desc = "Buffer Delete" })
vim.keymap.set("n", "<Tab>", "<cmd>wincmd w<CR>", { desc = "Move to next buffer" })
vim.keymap.set("n", "<leader>vs", "<cmd>vs<CR>", { desc = "New [V]ertical [S]plit" })
vim.keymap.set("n", "<leader>mx", "<cmd>MaximizerToggle<CR>", { desc = "[M]a[x]imize current buffer" })

-- Markdown Preview
vim.keymap.set("n", "<leader>md", "<cmd>MarkdownPreviewToggle<CR>", { desc = "[M]ark[D]own preview" })
