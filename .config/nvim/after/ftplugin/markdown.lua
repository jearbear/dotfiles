local u = require("utils")

if vim.bo.buftype == "nofile" then
    -- hide concealed text for hover windows
    vim.wo.conceallevel = 2
else
    vim.wo.conceallevel = 0
end
vim.bo.shiftwidth = 2
vim.bo.softtabstop = 2

u.map({ "n" }, "<C-.>", function()
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
