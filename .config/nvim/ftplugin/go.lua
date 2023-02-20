local u = require("utils")

vim.bo.expandtab = false
vim.bo.shiftwidth = 8
vim.bo.textwidth = 100

u.map("n", "<Leader>ct", ":edit %<C-z><Left><Left><Left>_test<CR>", { buffer = 0 })

vim.cmd([[
let g:test#transformation = 'go'
]])
