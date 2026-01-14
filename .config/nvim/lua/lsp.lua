local u = require("utils")
local fzf = require("fzf-lua")

vim.diagnostic.config({
    virtual_text = false,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    jump = {
        float = { border = "single" },
        wrap = false,
    },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "●",
            [vim.diagnostic.severity.WARN] = "●",
            [vim.diagnostic.severity.INFO] = "●",
            [vim.diagnostic.severity.HINT] = "●",
        },
    },
})

for name, config in pairs({
    ["*"] = {
        root_markers = { ".git" },
    },
    basedpyright = {
        cmd = { "basedpyright-langserver", "--stdio" },
        filetypes = { "python" },
        settings = {
            basedpyright = {
                analysis = {
                    typeCheckingMode = "off",
                    ignore = { "*" },
                },
            },
        },
    },
    ruff = {
        cmd = { "ruff", "server" },
        filetypes = { "python" },
    },
    elixirls = {
        cmd = { "elixir-ls" },
        filetypes = { "elixir" },
        settings = {
            dialyzerEnabled = false,
            incrementalDialyzer = false,
            mcpEnabled = false,
            autoBuild = false,
        },
    },
    marksman = {
        cmd = { "marksman" },
        filetypes = { "markdown" },
    },
    vtsls = {
        cmd = { "vtsls", "--stdio" },
        filetypes = { "typescript", "typescriptreact" },
    },
    luals = {
        cmd = { "lua-language-server" },
        filetypes = { "lua" },
        settings = {
            Lua = {},
        },
        on_init = function(client)
            if client.workspace_folders then
                local path = client.workspace_folders[1].name
                if
                    path ~= vim.fn.stdpath("config")
                    and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
                then
                    return
                end
            end
            client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
                runtime = {
                    -- Tell the language server which version of Lua you're using (most
                    -- likely LuaJIT in the case of Neovim)
                    version = "LuaJIT",
                    -- Tell the language server how to find Lua modules same way as Neovim
                    -- (see `:h lua-module-load`)
                    path = {
                        "lua/?.lua",
                        "lua/?/init.lua",
                    },
                },
                -- Make the server aware of Neovim runtime files
                workspace = {
                    checkThirdParty = false,
                    library = { vim.env.VIMRUNTIME },
                },
            })
        end,
    },
}) do
    vim.lsp.config(name, config)
    if name ~= "*" then
        vim.lsp.enable(name)
    end
end

u.autocmd({ "LspAttach" }, {
    callback = function(args)
        vim.lsp.completion.enable(true, args.data.client_id, args.buf, { autotrigger = false })

        -- Continue to use `gq` for line wrapping, not auto-formatting
        vim.bo.formatexpr = ""

        local function map(lhs, rhs)
            u.map("n", lhs, rhs, { buffer = args.buf })
        end

        vim.keymap.set("i", "<C-Space>", function()
            if vim.fn.pumvisible() ~= 0 then
                return "<C-y>"
            else
                return "<C-x><C-o>"
            end
        end, { expr = true, buffer = args.buf })

        map("K", vim.lsp.buf.hover)
        map("<Leader>R", vim.lsp.buf.rename)
        map("<C-k>", function()
            vim.diagnostic.jump({ count = -1 })
        end)
        map("<C-j>", function()
            vim.diagnostic.jump({ count = 1 })
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
            vim.diagnostic.setqflist({ open = true })
        end)
    end,
})
