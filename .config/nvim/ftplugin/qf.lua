local u = require("utils")

vim.cmd("packadd cfilter")

-- automaticaly move quickfix window to the bottom-most position of the
-- screen
vim.cmd("wincmd J")

u.map("n", "dd", "`R", { buffer = 0, remap = true })

u.map("n", "<BS>", "<Nop>", { buffer = 0 })
u.map_c("q", "q", { buffer = 0 })
u.map_c("Q", "q", { buffer = 0 })

u.buf_command(0, "Keep", "Cfilter <args>", { nargs = "*" })
u.buf_command(0, "Reject", "Cfilter! <args>", { nargs = "*" })
