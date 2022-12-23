vim.bo.formatprg = "pg_format"
vim.bo.omnifunc = "vim_dadbod_completion#omni"

local cmp = require("cmp")
cmp.setup.buffer({
    sources = cmp.config.sources({
        { name = "vim-dadbod-completion" },
    }, {
        { name = "snippy" },
    }),
})
