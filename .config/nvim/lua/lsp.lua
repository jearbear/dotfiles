local u = require("utils")
local lspconfig = require("lspconfig")
local null_ls = require("null-ls")
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local fzf = require("fzf-lua")

-- This function gets executed when the LSP is initiated successfully
local on_attach = function(client, bufnr)
    -- Provide LSP results to omni completion
    vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"

    -- I use gq mostly to wrap long lines, I don't care about LSP niceties
    vim.bo.formatexpr = ""

    -- New files tend to break the LSP so make a shorter command to make this
    -- easier to manage
    vim.api.nvim_create_user_command("LR", "LspRestart", {})

    -- Mappings
    local function map(lhs, rhs)
        u.map("n", lhs, rhs, { buffer = bufnr })
    end

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
    map("<Leader>gi", vim.lsp.buf.implementation)
    map("<Leader>ca", fzf.lsp_code_actions)

    map("<Leader>m", function()
        vim.diagnostic.setqflist({ open = false })
        if not vim.tbl_isempty(vim.fn.getqflist()) then
            vim.cmd("copen")
        else
            print("No diagnostic errors.")
        end
    end)

    -- Enable auto-formatting if it's provided
    if client.server_capabilities.documentFormattingProvider then
        u.autocmd("BufWritePre", {
            buffer = 0,
            callback = function()
                vim.lsp.buf.format({ timeout_ms = 5000, async = false })
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
local capabilities = cmp_nvim_lsp.default_capabilities()

local override_formatting_capability = function(client, override)
    client.server_capabilities.documentFormattingProvider = override
    client.server_capabilities.documentRangeFormattingProvider = override
end

-- Golang
lspconfig.gopls.setup({
    on_attach = function(client, bufnr)
        on_attach(client, bufnr)

        -- Disabling gopls's formatting and imports as it misses some
        -- situations when compared to goimports
        override_formatting_capability(client, false)
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

        -- Leave formatting up to eslint language server
        override_formatting_capability(client, false)
    end,
    handlers = handlers,
    capabilities = capabilities,
})

-- Eslint
lspconfig.eslint.setup({
    on_attach = function(client, bufnr)
        on_attach(client, bufnr)

        -- This LS doesn't broadcast formatting support initially and Neovim
        -- doesn't support dynamic registration so force broadcasting
        -- formatting capabilities.
        override_formatting_capability(client, true)
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
lspconfig.sumneko_lua.setup({
    on_attach = function(client, bufnr)
        on_attach(client, bufnr)

        -- Leave formatting up to stylua provided by null-ls
        override_formatting_capability(client, false)
    end,
    handlers = handlers,
    capabilities = capabilities,
})

-- Rust
lspconfig.rust_analyzer.setup({
    on_attach = on_attach,
    handlers = handlers,
    capabilities = capabilities,
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

-- Jsonnet (for gmailctl)
lspconfig.jsonnet_ls.setup({
    on_attach = on_attach,
    handlers = handlers,
    capabilities = capabilities,

    single_file_support = true,
})

-- Python
lspconfig.pylsp.setup({
    on_attach = on_attach,
    handlers = handlers,
    capabilities = capabilities,

    settings = {
        pylsp = {
            plugins = {
                black = {
                    enabled = true,
                },
                ["pylsp-mypy"] = {
                    enabled = true,
                    live_mode = true,
                },
            },
        },
    },
})

-- null-ls
null_ls.setup({
    sources = {
        -- shellcheck
        null_ls.builtins.diagnostics.shellcheck,
        null_ls.builtins.code_actions.shellcheck,

        -- elixir
        null_ls.builtins.diagnostics.credo,

        -- golang
        null_ls.builtins.diagnostics.golangci_lint.with({
            args = { "run", "--fix=false", "--out-format=json", "$DIRNAME", "--path-prefix", "$ROOT" },
        }),
        null_ls.builtins.formatting.gofumpt,
        null_ls.builtins.formatting.goimports.with({
            extra_args = { "-local", "github.com/pipe-technologies/pipe/backend" },
        }),

        -- lua
        -- Using stylua instead of LSP formatter since it's more opinionated.
        null_ls.builtins.formatting.stylua.with({
            extra_args = { "--indent-type", "Spaces" },
        }),

        null_ls.builtins.formatting.prettierd.with({
            filetypes = { "html", "css", "json", "yaml", "markdown", "graphql" },
        }),

        -- git
        null_ls.builtins.code_actions.gitsigns,
    },

    on_attach = on_attach,
    handlers = handlers,

    -- Look for language-specific files first to better handle mono-repos.
    root_dir = lspconfig.util.root_pattern("tsconfig.json", "go.mod", ".git"),
})
