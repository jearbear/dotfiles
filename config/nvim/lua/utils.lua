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

function M.nnoremap_c(lhs, rhs)
    vim.api.nvim_set_keymap("n", lhs, "<Cmd>" .. rhs .. "<CR>", { noremap = true, silent = true })
end

function M.buf_nnoremap(buf_number, lhs, rhs)
    vim.api.nvim_buf_set_keymap(buf_number, "n", lhs, rhs, { noremap = true })
end

function M.buf_nnoremap_c(buf_number, lhs, rhs)
    vim.api.nvim_buf_set_keymap(buf_number, "n", lhs, "<Cmd>" .. rhs .. "<CR>", { noremap = true, silent = true })
end

function M.inoremap(lhs, rhs)
    vim.api.nvim_set_keymap("i", lhs, rhs, { noremap = true })
end

function M.cnoremap(lhs, rhs)
    vim.api.nvim_set_keymap("c", lhs, rhs, { noremap = true })
end

function M.cnoremap_c(lhs, rhs)
    vim.api.nvim_set_keymap("c", lhs .. "<CR>", rhs .. "<CR>", { noremap = true })
end

function M.xnoremap_c(lhs, rhs)
    vim.api.nvim_set_keymap("x", lhs, "<Cmd>" .. rhs .. "<CR>", { noremap = true, silent = true })
end

function M.toggle_qf()
    for _, win in pairs(vim.fn.getwininfo()) do
        if win["quickfix"] == 1 then
            vim.cmd("cclose")
            return
        end
    end

    if not vim.tbl_isempty(vim.fn.getqflist()) then
        vim.cmd("copen")
    end
end

function M.keep_qf(pattern)
    local all = vim.fn.getqflist()
    local new = {}
    for _, entry in pairs(all) do
        if string.find(vim.fn.bufname(entry.bufnr), pattern) then
            table.insert(new, entry)
        end
    end
    vim.fn.setqflist(new)
    vim.fn.setqflist({}, "a", { title = "Keep: `" .. pattern .. "`" })
end

function M.reject_qf(pattern)
    local all = vim.fn.getqflist()
    local new = {}
    for _, entry in pairs(all) do
        if not string.find(vim.fn.bufname(entry.bufnr), pattern) then
            table.insert(new, entry)
        end
    end
    vim.fn.setqflist(new)
    vim.fn.setqflist({}, "a", { title = "Reject: `" .. pattern .. "`" })
end

return M
