local u = require("utils")
local lspconfig = require("lspconfig")
local configs = require("lspconfig.configs")
local fzf = require("fzf-lua")

local min_severity = { min = vim.diagnostic.severity.HINT }

vim.diagnostic.config({
    virtual_text = false,
    signs = { severity = min_severity },
    underline = true,
    update_in_insert = false,
    severity_sort = true,
})

-- This function gets executed when the LSP is initiated successfully
local on_attach = function(client, bufnr)
    -- I use gq mostly to wrap long lines, I don't need a mapping for
    -- formatting since I almost always do it on save
    vim.bo.formatexpr = ""

    -- New files tend to break the LSP so make a shorter command
    -- to make this easier to manage
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
            severity = min_severity,
        })
    end)
    map("<C-j>", function()
        vim.diagnostic.goto_next({
            float = { border = "single" },
            wrap = false,
            severity = min_severity,
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
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.format({ timeout_ms = 2000, async = false })
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

local capabilities = require("cmp_nvim_lsp").default_capabilities()

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

lspconfig.tsserver.setup({
    on_attach = function(client, bufnr)
        -- Formatting is handled by eslint
        override_formatting_capability(client, false)
        on_attach(client, bufnr)
    end,
    handlers = handlers,
    capabilities = capabilities,
    settings = {
        separate_diagnostic_server = true,
        -- include_completions_with_insert_text = false,
        tsserver_file_preferences = {
            autoImportFileExcludePatterns = {
                "antd",
                "react-i18next",
                "i18next",
                "module",
                "webpack",
            },
        },
    },
})

-- Eslint
lspconfig.eslint.setup({
    on_attach = function(client, bufnr)
        -- This LS doesn't broadcast formatting support initially and Neovim
        -- doesn't support dynamic registration so force broadcasting
        -- formatting capabilities.
        override_formatting_capability(client, true)
        on_attach(client, bufnr)
    end,
    handlers = handlers,
    capabilities = capabilities,
})

-- Elixir
-- lspconfig.elixirls.setup({
--     on_attach = on_attach,
--     handlers = handlers,
--     cmd = { "/opt/homebrew/bin/elixir-ls" },
--     settings = {
--         dialyzerEnabled = false,
--     },
-- })

-- Things this currently does better:
--  slightly smarter auto-completion
--  doesn't seem to crash randomly
-- Things this does worse (and thus why I don't use it yet):
--  much slower startup time (which blocks saving until it's done)
--  throws in snippets in a bunch of completions, which mini.completion does not support yet
--  doesn't support workspace symbols
lspconfig.lexical.setup({
    on_attach = on_attach,
    handlers = handlers,
    capabilities = capabilities,
    cmd = { vim.env.HOME .. "/Projects/lexical/_build/dev/package/lexical/bin/start_lexical.sh" },
})

-- Lua
lspconfig.lua_ls.setup({
    on_attach = function(client, bufnr)
        on_attach(client, bufnr)

        -- Leave formatting up to stylua
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

-- Python
lspconfig.pyright.setup({
    on_attach = on_attach,
    handlers = handlers,
    capabilities = capabilities,
    settings = {
        pyright = {
            -- Use Ruff instead
            disableOrganizeImports = true,
        },
        python = {
            analysis = {
                typeCheckingMode = "off",
                ignore = { "*" },
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
