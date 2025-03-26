vim.bo.shiftwidth = 2
vim.bo.softtabstop = 2

local mini_ai = require("mini.ai")
vim.b.miniai_config = {
    custom_textobjects = {
        -- Update tags pattern to support HEEX components
        t = mini_ai.gen_spec.treesitter({ a = "@tag.outer", i = "@tag.inner" }),
    },
}

require("nvim-surround").buffer_setup({
    surrounds = {
        ["h"] = {
            add = { '~H"""', '"""' },
        },
        ["m"] = {
            add = { "%{", "}" },
        },
    },
})
