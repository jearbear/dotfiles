local lspconfig = require("lspconfig")
local null_ls = require("null-ls")

function goimports() -- Copied from https://github.com/golang/tools/blob/master/gopls/doc/vim.md#neovim-imports {{{
    local context = { only = { "source.organizeImports" } }
    vim.validate({ context = { context, "t", true } })

    local params = vim.lsp.util.make_range_params()
    params.context = context

    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 1000)
    if not result or next(result) == nil then
        return
    end
    local actions = result[1].result
    if not actions then
        return
    end
    local action = actions[1]

    if action.edit or type(action.command) == "table" then
        if action.edit then
            vim.lsp.util.apply_workspace_edit(action.edit)
        end
        if type(action.command) == "table" then
            vim.lsp.buf.execute_command(action.command)
        end
    else
        vim.lsp.buf.execute_command(action)
    end
end
-- }}}

-- This function gets executed when the LSP is initiated successfully
local on_attach = function(client, bufnr)
    local function buf_set_keymap(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
    end
    local function buf_set_option(...)
        vim.api.nvim_buf_set_option(bufnr, ...)
    end

    -- Enable completion triggered by <c-x><c-o>
    buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

    -- Mappings
    local opts = { noremap = true, silent = true }
    buf_set_keymap("n", "<C-]>", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
    buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
    buf_set_keymap("n", "<Leader>R", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
    buf_set_keymap(
        "n",
        "<C-k>",
        '<cmd>lua vim.diagnostic.goto_prev({float = { border = "single" }, wrap = false})<CR>',
        opts
    )
    buf_set_keymap(
        "n",
        "<C-j>",
        '<cmd>lua vim.diagnostic.goto_next({float = { border = "single" }, wrap = false})<CR>',
        opts
    )
    buf_set_keymap("n", "<Leader>gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
    buf_set_keymap("n", "<Leader>M", "<cmd>lua vim.diagnostic.setqflist()<CR>", opts)
    buf_set_keymap("n", "<Leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)

    -- Enable auto-formatting if it's provided
    if client.resolved_capabilities.document_formatting then
        vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
    end

    -- Update signs
    local signs = { Error = "!!", Warn = "!!", Hint = "ii", Info = "ii" }
    for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    end
end

-- These are callbacks for various LSP functions that can configure their behavior
local handlers = {
    ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" }),
    ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" }),
    ["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = {
            prefix = "■",
        },
    }),
}

-- Golang
lspconfig.gopls.setup({
    on_attach = function(client, bufnr)
        on_attach(client, bufnr)

        -- Enable auto-formatting of imports
        vim.cmd("autocmd BufWritePre <buffer> lua goimports()")
    end,
    handlers = handlers,

    settings = {
        gopls = {
            gofumpt = true,
        },
    },
})

-- Typescript
lspconfig.tsserver.setup({
    on_attach = function(client, bufnr)
        on_attach(client, bufnr)

        -- Leave formatting up to eslint_d and prettierd provided by null-ls
        client.resolved_capabilities.document_formatting = false
        client.resolved_capabilities.document_range_formatting = false
    end,
    handlers = handlers,
})

-- Elixir
lspconfig.elixirls.setup({
    on_attach = on_attach,
    handlers = handlers,

    cmd = { "/opt/homebrew/bin/elixir-ls" },
})

-- null-ls
null_ls.setup({
    sources = {
        null_ls.builtins.formatting.prettierd,
        null_ls.builtins.formatting.eslint_d,
        null_ls.builtins.diagnostics.eslint_d,
        null_ls.builtins.diagnostics.golangci_lint.with({
            args = { "run", "--fix=false", "--out-format=json", "$DIRNAME", "--path-prefix", "$ROOT" },
        }),
        null_ls.builtins.formatting.stylua.with({
            extra_args = { "--indent-type", "Spaces" },
        }),
    },

    on_attach = on_attach,
    handlers = handlers,
})
