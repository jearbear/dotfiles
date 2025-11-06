local u = require("utils")
local lspconfig = require("lspconfig")
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
    -- vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"

    -- I use gq mostly to wrap long lines, I don't need a mapping for
    -- formatting since I almost always do it on save
    vim.bo.formatexpr = ""

    -- New files tend to break the LSP so make a shorter command
    -- to make this easier to manage
    vim.api.nvim_create_user_command("LR", "LspRestart", {})

    if client:supports_method("textDocument/completion") then
        vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = false })
        u.map("i", "<C-Space>", function()
            if vim.fn.pumvisible() ~= 0 then
                return "<C-y>"
            else
                vim.lsp.completion.get()
                return ""
            end
        end, { expr = true, silent = true })
    end

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
    map("<Leader>gt", function()
        vim.lsp.buf.type_definition()
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

    -- Update signs
    local sign = "⏵"
    local signs = { Error = sign, Warn = sign, Hint = sign, Info = sign }
    for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    end
end

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
    settings = {
        gopls = {
            usePlaceholders = true,
        },
    },
})

lspconfig.ts_ls.setup({
    on_attach = function(client, bufnr)
        -- Formatting is handled by eslint
        override_formatting_capability(client, false)
        on_attach(client, bufnr)
    end,
    handlers = handlers,
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
        compilerOptions = {
            noErrorTruncation = true,
        },
    },
})

-- Elixir
lspconfig.elixirls.setup({
    on_attach = on_attach,
    handlers = handlers,
    cmd = { "/opt/homebrew/bin/elixir-ls" },
    settings = {
        dialyzerEnabled = false,
        incrementalDialyzer = false,
    },
})

-- Lua
lspconfig.lua_ls.setup({
    on_attach = function(client, bufnr)
        on_attach(client, bufnr)

        -- Leave formatting up to stylua
        override_formatting_capability(client, false)
    end,
    handlers = handlers,
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
})

-- Tailwind
lspconfig.tailwindcss.setup({
    on_attach = on_attach,
    handlers = handlers,
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
    init_options = {
        provideFormatter = false,
    },
})

-- yaml
lspconfig.yamlls.setup({
    on_attach = on_attach,
    handlers = handlers,
})

-- terraforml-ls
lspconfig.terraformls.setup({
    on_attach = on_attach,
    handlers = handlers,
})

-- taplo
lspconfig.taplo.setup({
    on_attach = on_attach,
    handlers = handlers,
})

-- marksman
lspconfig.marksman.setup({
    on_attach = on_attach,
    handlers = handlers,
})

-- elm
lspconfig.elmls.setup({
    on_attach = on_attach,
    handlers = handlers,
})

-- efm
lspconfig.efm.setup({
    on_attach = on_attach,
    handlers = handlers,
})
