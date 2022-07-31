local u = require("utils")
local lspconfig = require("lspconfig")
local null_ls = require("null-ls")
local cmp_nvim_lsp = require("cmp_nvim_lsp")

-- This function gets executed when the LSP is initiated successfully
local on_attach = function(client, bufnr)
    -- Provide LSP results to omni completion
    vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"

    -- New files tend to break the LSP so make a shorter command to make this easier to manage
    vim.api.nvim_create_user_command("LR", "LspRestart", {})

    -- Mappings
    local function map(lhs, rhs)
        u.map("n", lhs, rhs, { buffer = bufnr })
    end

    map("<C-]>", vim.lsp.buf.definition)
    map("K", vim.lsp.buf.hover)
    map("<Leader>R", vim.lsp.buf.rename)
    map("<C-k>", function()
        vim.diagnostic.goto_prev({ float = { border = "single" }, wrap = false })
    end)
    map("<C-j>", function()
        vim.diagnostic.goto_next({ float = { border = "single" }, wrap = false })
    end)
    map("<Leader>gr", function()
        vim.lsp.buf.references({ includeDeclaration = false })
    end)
    map("<Leader>ca", vim.lsp.buf.code_action)

    u.map("n", "<Leader>m", function()
        vim.diagnostic.setqflist({ open = false })
        if not vim.tbl_isempty(vim.fn.getqflist()) then
            vim.cmd("copen")
        else
            print("No diagnostic errors!")
        end
    end, { buffer = bufnr })

    -- Enable auto-formatting if it's provided
    if client.resolved_capabilities.document_formatting then
        u.autocmd("BufWritePre", {
            buffer = 0,
            callback = function()
                vim.lsp.buf.formatting_sync({}, 5000)
            end,
        })
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
    -- Filter out some annoying results
    -- See: https://github.com/typescript-language-server/typescript-language-server/issues/216#issuecomment-1005272952
    ["textDocument/definition"] = function(err, results, method, ...)
        if not vim.tbl_islist(results) or #results <= 1 then
            return vim.lsp.handlers["textDocument/definition"](err, results, method, ...)
        end

        local filtered_results = u.filter(results, function(v)
            -- Filter out TS type annotations
            return string.match(v.uri, "d.ts") == nil
        end)
        return vim.lsp.handlers["textDocument/definition"](err, filtered_results, method, ...)
    end,
}

-- Add completion via cmp-nvim to the list of LSP capabilities available
local capabilities = cmp_nvim_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Golang
lspconfig.gopls.setup({
    on_attach = function(client, bufnr)
        on_attach(client, bufnr)

        -- Disabling gopls's formatting and imports as it misses some
        -- situations when compared to goimports
        client.resolved_capabilities.document_formatting = false
        client.resolved_capabilities.document_range_formatting = false
    end,
    handlers = handlers,
    capabilities = capabilities,

    settings = {
        gopls = {
            usePlaceholders = true,
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
lspconfig.sumneko_lua.setup(require("lua-dev").setup({
    runtime_path = true, -- enable completions for `require`
    lspconfig = {
        on_attach = on_attach,
        handlers = handlers,
        capabilities = capabilities,
    },
}))

-- Rust
lspconfig.rust_analyzer.setup({
    on_attach = on_attach,
    handlers = handlers,
    capabilities = capabilities,
})

-- Emmet
lspconfig.emmet_ls.setup({
    on_attach = on_attach,
    handlers = handlers,
    capabilities = capabilities,
    filetypes = { "html", "typescriptreact", "heex", "elixir" },
})

-- Tailwind
lspconfig.tailwindcss.setup({
    on_attach = on_attach,
    handlers = handlers,
    capabilities = capabilities,

    filetypes = {
        "html",
        "heex",
        "elixir",
    },

    init_options = {
        userLanguages = {
            heex = "html-eex",
            elixir = "html-eex",
        },
    },
})

-- null-ls
null_ls.setup({
    sources = {
        -- shellcheck
        null_ls.builtins.diagnostics.shellcheck,
        null_ls.builtins.code_actions.shellcheck,

        -- javascript, typescript
        null_ls.builtins.code_actions.eslint_d,
        -- Much faster than eslint_d at linting since it has to do less. Can
        -- rely on code actions to fix up the things that eslint_d complains
        -- about.
        null_ls.builtins.formatting.prettierd,
        null_ls.builtins.diagnostics.eslint_d,

        -- golang
        null_ls.builtins.diagnostics.golangci_lint.with({
            args = { "run", "--fix=false", "--out-format=json", "$DIRNAME", "--path-prefix", "$ROOT" },
        }),
        null_ls.builtins.formatting.gofumpt,
        null_ls.builtins.formatting.goimports.with({
            extra_args = { "-local", "github.com/pipe-technologies/pipe/backend" },
        }),

        -- lua
        null_ls.builtins.formatting.stylua.with({
            extra_args = { "--indent-type", "Spaces" },
        }),
    },

    on_attach = on_attach,
    handlers = handlers,

    -- Look for language-specific files first to better handle mono-repos.
    root_dir = lspconfig.util.root_pattern("tsconfig.json", "go.mod", ".git"),
})
