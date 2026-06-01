local u = require("utils")

vim.bo.expandtab = false
vim.bo.softtabstop = 8
vim.bo.tabstop = 8
vim.bo.shiftwidth = 0
vim.bo.textwidth = 100

u.map("n", "<Leader>ct", ":edit %<C-z><Left><Left><Left>_test<CR>", { buffer = 0 })

vim.cmd([[
let g:test#transformation = 'go'
]])

-- Auto formatting that will also organize imports
-- Source: https://go.dev/gopls/editor/vim#neovim-imports
u.autocmd({ "BufWritePre" }, {
    buffer = 0,
    callback = function()
        local params = vim.lsp.util.make_range_params(0, "utf-8")
        params.context = { only = { "source.organizeImports" } }
        local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 1000)
        for cid, res in pairs(result or {}) do
            for _, r in pairs(res.result or {}) do
                if r.edit then
                    local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
                    vim.lsp.util.apply_workspace_edit(r.edit, enc)
                end
            end
        end
        vim.lsp.buf.format({ async = false })
    end,
})
