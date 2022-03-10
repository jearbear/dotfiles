require("lualine").setup({
    options = {
        icons_enabled = true,
        theme = "auto",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {},
        always_divide_middle = true,
    },
    sections = {
        lualine_a = { "mode" },
        lualine_b = {
            {
                "tabs",
                max_length = vim.o.columns,
                mode = 0, -- show tab number only
                cond = function()
                    return vim.fn.tabpagenr("$") > 1
                end,
            },
        },
        lualine_c = {
            {
                "filename",
                path = 1, -- display relative path
                symbols = {
                    modified = " [+]",
                    readonly = " [-]",
                    unnamed = "[No Name]",
                },
                padding = 2,
            },
        },
        lualine_x = {
            {
                "branch",
                padding = 2,
            },
        },
        lualine_y = {
            {
                "diagnostics",
                sources = { "nvim_lsp" },
                symbols = { error = "", warn = "", info = "", hint = "" },
            },
        },
        lualine_z = { "%l:%L" },
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "%l:%L" },
        lualine_y = {},
        lualine_z = {},
    },
    tabline = {},
    extensions = { "quickfix" },
})
