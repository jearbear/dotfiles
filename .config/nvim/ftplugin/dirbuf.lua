local u = require("utils")

u.map_c("q", "DirbufQuit", { buffer = 0 })

-- Work-around until this gets resolved:
-- https://github.com/nvim-treesitter/nvim-treesitter-context/issues/281
-- vim.cmd("TSContextDisable")
-- u.autocmd({ "BufLeave" }, {
--     pattern = "<buffer>",
--     callback = function()
--         print("LEAVING")
--         vim.cmd("TSContextEnable")
--     end,
--     group = u.augroup("DIRBUF"),
-- })
