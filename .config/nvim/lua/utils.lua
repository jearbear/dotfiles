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

M.unmap = vim.keymap.del
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

M.set_indent_guide = function()
    local guide = string.rep(" ", vim.bo.shiftwidth - 1)
    vim.opt_local.list = true
    vim.opt_local.listchars = {
        -- repeat enough times to not have to rely on the built-in repeat which
        -- will look off by one
        leadmultispace = " " .. string.rep(guide .. "│", 100),
    }
end

return M
