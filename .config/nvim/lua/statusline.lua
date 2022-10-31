require("lualine").setup({
    options = {
        icons_enabled = false,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {},
        always_divide_middle = false,
    },
    sections = {
        lualine_a = {
            {
                "mode",
                fmt = function(str)
                    if vim.fn.winwidth(0) < 120 then
                        return str:sub(1, 1)
                    end
                    return str
                end,
            },
        },
        lualine_b = {
            {
                "tabs",
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
                cond = function()
                    return vim.fn.winwidth(0) >= 120
                end,
            },
        },
        lualine_y = {
            {
                "diagnostics",
                sources = { "nvim_diagnostic" },
                symbols = { error = "", warn = "", info = "", hint = "" },
            },
        },
        lualine_z = { "%l:%L" },
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
            {
                "filename",
                path = 1,
                symbols = {
                    modified = " [+]",
                    readonly = " [-]",
                    unnamed = "[No Name]",
                },
                padding = 2,
            },
        },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
    },
    tabline = {},
    extensions = { "quickfix" },
})
