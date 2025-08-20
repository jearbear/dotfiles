local u = require("utils")

vim.opt_local.conceallevel = 0
vim.bo.shiftwidth = 2
vim.bo.softtabstop = 2

u.map({ "i", "n" }, "<C-.>", function()
    local line = vim.api.nvim_get_current_line()
    local line_start, _ = line:find("- %[.-%]")

    if line_start then
        if line:find("%[x%]", line_start) then
            line = line:gsub("%[x%]", "[ ]", 1)
        else
            line = line:gsub("%[ %]", "[x]", 1)
        end
        vim.api.nvim_set_current_line(line)
    end
end)
