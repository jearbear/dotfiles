local u = require("utils")

u.buf_nnoremap(0, "<BS>", "<Nop>")
u.buf_nnoremap_c(0, "q", "q")
u.buf_nnoremap_c(0, "Q", "q")
