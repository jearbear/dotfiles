local u = require("utils")

vim.bo.expandtab = false
vim.bo.shiftwidth = 8
vim.bo.textwidth = 100

u.buf_nnoremap(0, "<Leader>ct", ":edit %<C-z><Left><Left><Left>_test<CR>")
