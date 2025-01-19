local u = require("utils")

vim.wo.foldenable = true
vim.wo.foldmethod = "marker"

-- Undo custom mapping
u.map("n", "<CR>", "<CR>", { buffer = true })
