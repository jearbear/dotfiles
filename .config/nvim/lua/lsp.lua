local u = require("utils")
local lspconfig = require("lspconfig")
local null_ls = require("null-ls")
local fzf = require("fzf-lua")

local min_severity = { min = vim.diagnostic.severity.INFO }

vim.diagnostic.config({
    virtual_text = false,
    signs = { severity = min_severity },
    underline = true,
    update_in_insert = false,
    severity_sort = true,
})

-- This function gets executed when the LSP is initiated successfully
local on_attach = function(client, bufnr)
    -- Provide LSP results to omni completion
    vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"

    -- I use gq mostly to wrap long lines, I don't need a mapping for it since
    -- I almost always do it on save
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
        vim.diagnostic.goto_prev({
            float = { border = "single" },
            wrap = false,
        })
    end)
    map("<C-j>", function()
        vim.diagnostic.goto_next({
            float = { border = "single" },
            wrap = false,
        })
    end)
    -- TODO: Make this automatically filter out references coming from imports
    map("<Leader>gr", function()
        vim.lsp.buf.references({ includeDeclaration = false })
    end)
    map("<Leader>gi", vim.lsp.buf.implementation)
    map("<Leader>ca", fzf.lsp_code_actions)

    map("<Leader>m", function()
        vim.diagnostic.setqflist({
            open = false,
            severity = min_severity,
        })
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
                -- yapf is slow AF
                if vim.bo.filetype == "python" then
                    vim.lsp.buf.format({ async = true })
                else
                    vim.lsp.buf.format({ timeout_ms = 5000, async = false })
                end
            end,
        })
    end

    -- Update signs
    local sign = "⏵"
    local signs = { Error = sign, Warn = sign, Hint = sign, Info = sign }
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
local typescript = require("typescript")
typescript.setup({
    go_to_source_definition = {
        fallback = true,
    },
    server = {
        on_attach = function(client, bufnr)
            on_attach(client, bufnr)

            u.map_c("<C-]>", "TypescriptGoToSourceDefinition", { buffer = bufnr })

            u.buf_command(bufnr, "TRF", function(_)
                vim.cmd("TypescriptRenameFile")
            end, { nargs = 0 })
            u.buf_command(bufnr, "TAMI", typescript.actions.addMissingImports, { nargs = 0 })
            u.buf_command(bufnr, "TRU", typescript.actions.removeUnused, { nargs = 0 })

            -- Leave formatting up to eslint language server
            -- override_formatting_capability(client, false)
        end,
        handlers = handlers,
        capabilities = capabilities,
    },
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
lspconfig.lua_ls.setup({
    on_attach = function(client, bufnr)
        on_attach(client, bufnr)

        -- Leave formatting up to stylua provided by null-ls
        override_formatting_capability(client, false)
    end,
    handlers = handlers,
    capabilities = capabilities,
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = "LuaJIT",
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { "vim" },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
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

-- Tailwind
lspconfig.tailwindcss.setup({
    on_attach = on_attach,
    handlers = handlers,
    capabilities = capabilities,
    filetypes = {
        "html",
        "javascriptreact",
        "typescriptreact",
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
lspconfig.pyright.setup({
    on_attach = function(client, bufnr)
        on_attach(client, bufnr)

        u.buf_command(bufnr, "PO", function(_)
            vim.cmd("PyrightOrganizeImports")
        end, { nargs = 0 })
    end,
    handlers = handlers,
    capabilities = capabilities,
    settings = {
        python = {
            analysis = {
                typeCheckingMode = "off",
            },
        },
    },
})

-- jsonls
lspconfig.jsonls.setup({
    on_attach = on_attach,
    handlers = handlers,
    capabilities = capabilities,
    init_options = {
        provideFormatter = false,
    },
})

-- terraforml-ls
lspconfig.terraformls.setup({
    on_attach = on_attach,
    handlers = handlers,
    capabilities = capabilities,
})

-- null-ls
null_ls.setup({
    sources = {
        -- shellcheck
        null_ls.builtins.diagnostics.shellcheck,
        null_ls.builtins.code_actions.shellcheck,

        -- golang
        null_ls.builtins.diagnostics.golangci_lint.with({
            args = { "run", "--fix=false", "--out-format=json", "$DIRNAME", "--path-prefix", "$ROOT" },
        }),
        null_ls.builtins.formatting.gofumpt,
        null_ls.builtins.formatting.goimports,

        -- lua
        -- Using stylua instead of LSP formatter since it's more opinionated.
        null_ls.builtins.formatting.stylua.with({
            extra_args = { "--indent-type", "Spaces" },
        }),

        null_ls.builtins.formatting.prettierd.with({
            filetypes = {
                -- "html",
                "css",
                "json",
                "yaml",
                "markdown",
                "graphql",
            },
        }),

        -- python
        null_ls.builtins.diagnostics.flake8, -- lint
        null_ls.builtins.formatting.yapf, -- auto-format
        null_ls.builtins.formatting.autoflake, -- auto-remove unused imports

        -- elixir
        null_ls.builtins.diagnostics.credo,
    },
    on_attach = on_attach,
    handlers = handlers,
    -- Look for language-specific files first to better handle mono-repos.
    root_dir = lspconfig.util.root_pattern("tsconfig.json", "go.mod", ".git"),
})
