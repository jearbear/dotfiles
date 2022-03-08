local M = {}

function M.map(lhs, rhs)
    vim.api.nvim_set_keymap("", lhs, rhs, {})
end

function M.nmap(lhs, rhs)
    vim.api.nvim_set_keymap("n", lhs, rhs, {})
end

function M.buf_nmap(buf_number, lhs, rhs)
    vim.api.nvim_buf_set_keymap(buf_number, "n", lhs, rhs, {})
end

function M.vmap(lhs, rhs)
    vim.api.nvim_set_keymap("v", lhs, rhs, {})
end

function M.xmap(lhs, rhs)
    vim.api.nvim_set_keymap("x", lhs, rhs, {})
end

function M.nnoremap(lhs, rhs)
    vim.api.nvim_set_keymap("n", lhs, rhs, { noremap = true })
end

function M.buf_nnoremap(buf_number, lhs, rhs)
    vim.api.nvim_buf_set_keymap(buf_number, "n", lhs, rhs, { noremap = true })
end

function M.inoremap(lhs, rhs)
    vim.api.nvim_set_keymap("i", lhs, rhs, { noremap = true })
end

function M.cnoremap(lhs, rhs)
    vim.api.nvim_set_keymap("c", lhs, rhs, { noremap = true })
end

function M.nnoremap_c(lhs, rhs)
    vim.api.nvim_set_keymap("n", lhs, "<Cmd>" .. rhs .. "<CR>", { noremap = true, silent = true })
end

function M.buf_nnoremap_c(buf_number, lhs, rhs)
    vim.api.nvim_buf_set_keymap(buf_number, "n", lhs, "<Cmd>" .. rhs .. "<CR>", { noremap = true, silent = true })
end

function M.xnoremap_c(lhs, rhs)
    vim.api.nvim_set_keymap("x", lhs, "<Cmd>" .. rhs .. "<CR>", { noremap = true, silent = true })
end

return M
