vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<leader>w", "<cmd>bd<cr>")
vim.keymap.set("n", "<leader>W", "<cmd>bd!<cr>")
vim.keymap.set("v", "<c-c>", '"*y', { noremap = true })
vim.keymap.set("n", "<c-v>", '"+p', { noremap = true })
vim.keymap.set("i", "<c-v>", '<C-o>"+p', { noremap = true })
