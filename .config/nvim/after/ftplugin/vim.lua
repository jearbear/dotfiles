local u = require("utils")

-- Undo custom mappings
vim.keymap.del("n", "<CR>", { buf = 0 })
