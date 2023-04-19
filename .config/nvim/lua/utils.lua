local M = {}

function M.augroup(name)
    vim.api.nvim_create_augroup(name, { clear = true })
end

function M.filter(arr, fn)
    if type(arr) ~= "table" then
        return arr
    end

    local filtered = {}
    for k, v in pairs(arr) do
        if fn(v, k, arr) then
            table.insert(filtered, v)
        end
    end

    return filtered
end

M.autocmd = vim.api.nvim_create_autocmd

M.command = vim.api.nvim_create_user_command

M.buf_command = vim.api.nvim_buf_create_user_command

M.map = vim.keymap.set
M.map_c = function(lhs, rhs, opts)
    vim.keymap.set("n", lhs, function()
        vim.cmd(rhs)
    end, opts)
end

M.table = {}

M.table.contains = function(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

return M
