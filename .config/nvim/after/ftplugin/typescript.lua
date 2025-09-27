vim.bo.shiftwidth = 2
vim.bo.softtabstop = 2

vim.cmd([[let b:tsc_makeprg = "just typecheck web"]])
vim.cmd([[compiler tsc]])
