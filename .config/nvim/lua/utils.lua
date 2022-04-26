local M = {}

function M.augroup(name)
    vim.api.nvim_create_augroup(name, { clear = true })
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

return M
