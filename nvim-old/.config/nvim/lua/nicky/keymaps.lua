vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Focus window to the left" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Focus window to the bottom" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Focus window to the top" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Focus window to the right" })

vim.keymap.set({ "n", "v" }, "<leader>p", [["+p]], { desc = "Paste from sytem clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank into sytem clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Yank line into system clipboard" })

vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected line up" })
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected line down" })
