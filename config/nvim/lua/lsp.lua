local u = require("utils")
local lspconfig = require("lspconfig")
local null_ls = require("null-ls")
local cmp_nvim_lsp = require("cmp_nvim_lsp")

function OrgGoImports(wait_ms) -- Copied from https://github.com/golang/tools/blob/master/gopls/doc/vim.md#imports {{{
    local params = vim.lsp.util.make_range_params()
    params.context = { only = { "source.organizeImports" } }
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, wait_ms)
    for _, res in pairs(result or {}) do
        for _, r in pairs(res.result or {}) do
            if r.edit then
                vim.lsp.util.apply_workspace_edit(r.edit)
            else
                vim.lsp.buf.execute_command(r.command)
            end
        end
    end
end
-- }}}

-- This function gets executed when the LSP is initiated successfully
local on_attach = function(client, bufnr)
    local function map(lhs, rhs)
        u.buf_nnoremap_c(bufnr, lhs, rhs)
    end

    -- Enable completion triggered by <c-x><c-o>
    vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"

    -- Mappings
    map("<C-]>", "lua vim.lsp.buf.definition()")
    map("<C-]>", "lua vim.lsp.buf.definition()")
    map("<C-]>", "lua vim.lsp.buf.definition()")
    map("K", "lua vim.lsp.buf.hover()")
    map("<Leader>R", "lua vim.lsp.buf.rename()")
    map("<C-k>", 'lua vim.diagnostic.goto_prev({float = { border = "single" }, wrap = false})')
    map("<C-j>", 'lua vim.diagnostic.goto_next({float = { border = "single" }, wrap = false})')
    map("<Leader>gr", "lua vim.lsp.buf.references()")
    map("<Leader>M", "lua vim.diagnostic.setqflist()")
    map("<Leader>ca", "lua vim.lsp.buf.code_action()")

    -- Enable auto-formatting if it's provided
    if client.resolved_capabilities.document_formatting then
        vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync(nil, 5000)")
    end

    -- Update signs
    local signs = { Error = "┇", Warn = "┇", Hint = "┇", Info = "┇" }
    for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    end
end

-- These are callbacks for various LSP functions that can configure their behavior
local handlers = {
    ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" }),
    ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" }),
}

-- Add completion via cmp-nvim to the list of LSP capabilities available
local capabilities = cmp_nvim_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Golang
lspconfig.gopls.setup({
    on_attach = function(client, bufnr)
        on_attach(client, bufnr)

        -- TODO: Disabling gopls's formatting and imports as it misses some situations when compared to goimports
        client.resolved_capabilities.document_formatting = false
        client.resolved_capabilities.document_range_formatting = false

        -- Enable auto-formatting of imports
        -- vim.cmd("autocmd BufWritePre <buffer> lua OrgGoImports(5000)")
    end,
    handlers = handlers,
    capabilities = capabilities,

    settings = {
        gopls = {
            usePlaceholders = true,

            -- TODO: Put this into a Pipe-specific config
            -- gofumpt = true,
            -- ["local"] = "github.com/pipe-technologies/pipe/backend",
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
    -- TODO: Figure out how to filter out deprecation warnings. Might need to
    -- wait until vim can filter out diagnostics by severity.
    -- handlers = {
    --     ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" }),
    --     ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" }),
    --     ["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    --         underline = { severity = { min = vim.diagnostic.severity.INFO } },
    --         virtual_text = false,
    --         signs = { severity = { min = vim.diagnostic.severity.INFO } },
    --     }),
    -- },
    capabilities = capabilities,
})

-- Elixir
lspconfig.elixirls.setup({
    on_attach = on_attach,
    handlers = handlers,
    capabilities = capabilities,

    cmd = { "/opt/homebrew/bin/elixir-ls" },
})

-- Vimscript
lspconfig.vimls.setup({
    on_attach = on_attach,
    handlers = handlers,
    capabilities = capabilities,
})

-- Lua
lspconfig.sumneko_lua.setup({
    on_attach = on_attach,
    handlers = handlers,
    capabilities = capabilities,

    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" },
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
            },
        },
    },
})

-- Rust
lspconfig.rust_analyzer.setup({
    on_attach = on_attach,
    handlers = handlers,
    capabilities = capabilities,
})

-- null-ls
null_ls.setup({
    sources = {
        null_ls.builtins.code_actions.eslint_d,
        -- Much faster than eslint_d at linting since it has to do less. Can
        -- rely on code actions to fix up the things that eslint_d complains
        -- about.
        null_ls.builtins.formatting.prettierd,
        null_ls.builtins.diagnostics.eslint_d,
        null_ls.builtins.diagnostics.golangci_lint.with({
            args = { "run", "--fix=false", "--out-format=json", "$DIRNAME", "--path-prefix", "$ROOT" },
            -- If the LSP catches errors, they will likely be compiler errors
            -- which need to be resolved before golangci-lint returns anything
            -- useful, so we shouldn't run it.
            -- TODO: Disabled this because if the buffer previously had a
            -- golangcilint error and then a new diagnostic error popped up,
            -- the old golangcilint errors would not get cleared out.
            -- runtime_condition = function(params)
            --     for _ in pairs(vim.diagnostic.get(params.bufnr)) do
            --         return false
            --     end
            --     return true
            -- end,
        }),
        null_ls.builtins.formatting.gofumpt,
        null_ls.builtins.formatting.goimports.with({
            extra_args = { "-local", "github.com/pipe-technologies/pipe/backend" },
        }),
        null_ls.builtins.formatting.stylua.with({
            extra_args = { "--indent-type", "Spaces" },
        }),
    },

    on_attach = on_attach,
    handlers = handlers,

    -- Look for language-specific files first to better handle mono-repos.
    root_dir = lspconfig.util.root_pattern("tsconfig.json", "go.mod", ".git"),
})
