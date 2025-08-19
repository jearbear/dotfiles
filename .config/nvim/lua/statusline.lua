local u = require("utils")
local lualine = require("lualine")


lualine.setup({
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
                    return str:sub(1, 1)
                end,
            },
        },
        lualine_b = {  },
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
        lualine_x = {},
        lualine_y = {
            {
                "diagnostics",
                sources = { "nvim_diagnostic" },
                sections = { "error", "warn", "info" },
                symbols = { error = "E/", warn = "W/", info = "I/" },
            },
        },
        lualine_z = { "%l" },
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {
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
        lualine_c = {},
        lualine_x = {},
        lualine_y = { "%l" },
        lualine_z = {},
    },
    tabline = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {
            {
                "tabs",
                max_length = vim.o.columns,
                mode = 2,
            },
        },
    },
    extensions = { "quickfix" },
})

vim.o.showtabline = 1
