local u = require("utils")

u.buf_nmap(0, "dd", "`D")

u.buf_nnoremap(0, "<BS>", "<Nop>")
u.buf_nnoremap_c(0, "q", "q")
u.buf_nnoremap_c(0, "Q", "q")

vim.cmd("command! -nargs=1 Reject lua require('utils').reject_qf(<q-args>)")
vim.cmd("command! -nargs=1 Keep lua require('utils').keep_qf(<q-args>)")
