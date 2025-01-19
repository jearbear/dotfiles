local u = require("utils")

u.set_indent_guide()

require("nvim-surround").buffer_setup({
    surrounds = {
        ['"'] = {
            add = { 'f"', '"' },
        },
        ["p"] = {
            add = { "print(", ")" },
        },
        ["d"] = {
            add = { "dict(", ")" },
        },
    },
})
