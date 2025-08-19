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
        ["s"] = {
            add = { "str(", ")" },
        },
    },
})

u.buf_command(0, "ToggleTestCode", function()
    local path = vim.fn.expand("%")
    local filename = vim.fn.expand("%:t")

    -- Go to code
    if path:match("^tests/") and filename:match("^test_") then
        local code_path = path:gsub("^tests/", ""):gsub(filename .. "$", filename:gsub("^test_", ""))

        if not vim.fn.filereadable(code_path) then
            vim.notify("Code file doesn't exist", vim.log.levels.WARN)
            return
        end

        vim.cmd("edit " .. code_path)
    -- Go to test
    else
        local test_path = "tests/" .. path:gsub(filename, "test_" .. filename)

        if not vim.fn.filereadable(test_path) then
            vim.notify("Test file doesn't exist", vim.log.levels.WARN)
            return
        end

        vim.cmd("edit " .. test_path)
    end
end, {})

u.map_c("<Leader><BS>", "ToggleTestCode", { buffer = 0 })
u.map_c("<Leader><C-h>", "ToggleTestCode", { buffer = 0 })
