local M = {}

local colors = require("catppuccin.palettes").get_palette("mocha")
M.colors = colors

function M.setup()
    vim.cmd("colorscheme catppuccin")

    require("catppuccin").setup({
        flavour = "mocha",
        transparent_background = false,
        default_integrations = false,
        integrations = {
            fzf = true,
            blink_cmp = true,
            nvim_surround = true,
            treesitter = true,
            gitsigns = true,
            markdown = true,
            mini = {
                enabled = true,
            },
            native_lsp = {
                enabled = true,
                virtual_text = {
                    errors = { "italic" },
                    hints = { "italic" },
                    warnings = { "italic" },
                    information = { "italic" },
                    ok = { "italic" },
                },
                underlines = {
                    errors = { "undercurl" },
                    hints = { "undercurl" },
                    warnings = { "undercurl" },
                    information = { "undercurl" },
                },
                inlay_hints = {
                    background = true,
                },
            },
            treesitter_context = true,
        },
    })

    -- Reset all treesitter colors
    for _, group in ipairs(vim.fn.getcompletion("@", "highlight")) do
        vim.api.nvim_set_hl(0, group, { fg = colors.text })
    end

    -- Apply my custom highlights
    for group, options in pairs({
        ["ModeMsg"] = { fg = colors.peach },
        ["Whitespace"] = { fg = colors.surface0 },

        ["@comment"] = { fg = colors.overlay0 },

        ["@string"] = { fg = colors.green },
        ["@string.special"] = { fg = colors.peach },
        ["@string.special.symbol"] = { fg = colors.lavender },

        ["@keyword"] = { fg = colors.mauve },
        ["@keyword.conditional"] = { fg = colors.mauve },
        ["@keyword.conditional.ternary"] = { fg = colors.mauve },
        ["@keyword.coroutine"] = { fg = colors.mauve },
        ["@keyword.debug"] = { fg = colors.mauve },
        ["@keyword.directive"] = { fg = colors.mauve },
        ["@keyword.directive.define"] = { fg = colors.mauve },
        ["@keyword.exception"] = { fg = colors.mauve },
        ["@keyword.function"] = { fg = colors.mauve },
        ["@keyword.import"] = { fg = colors.mauve },
        ["@keyword.modifier"] = { fg = colors.mauve },
        ["@keyword.operator"] = { fg = colors.mauve },
        ["@keyword.repeat"] = { fg = colors.mauve },
        ["@keyword.return"] = { fg = colors.mauve },
        ["@keyword.type"] = { fg = colors.mauve },

        ["@boolean"] = { fg = colors.peach },
        ["@number"] = { fg = colors.peach },
        ["@number.float"] = { fg = colors.peach },
        ["@constant"] = { fg = colors.peach },
        ["@constant.builtin"] = { fg = colors.peach },
        ["@operator"] = { fg = colors.red },
        ["@function"] = { fg = colors.lavender },
        ["@type.builtin"] = { fg = colors.lavender },
        ["@type"] = { fg = colors.lavender },
        ["@punctuation.delimiter"] = { fg = colors.overlay1 },
        ["@punctuation.bracket"] = { fg = colors.overlay1 },
        ["@punctuation.special"] = { fg = colors.peach },

        ["@markup.strong"] = { bold = true },
        ["@markup.italic"] = { italic = true },
        ["@markup.strikethrough"] = { strikethrough = true },
        ["@markup.underline"] = { underline = true },
        ["@markup.heading.markdown"] = { bold = true },
        ["@markup.heading.1.markdown"] = { fg = colors.red },
        ["@markup.heading.2.markdown"] = { fg = colors.peach },
        ["@markup.heading.3.markdown"] = { fg = colors.yellow },
        ["@markup.heading.4.markdown"] = { fg = colors.mauve },
        ["@markup.heading.5.markdown"] = { fg = colors.mauve },
        ["@markup.heading.6.markdown"] = { fg = colors.mauve },
        ["@markup.link"] = { fg = colors.blue },
        ["@markup.list"] = { fg = colors.peach },
        ["@markup.list.checked"] = { fg = colors.peach },
        ["@markup.list.unchecked"] = { fg = colors.peach },
    }) do
        vim.api.nvim_set_hl(0, group, options)
    end
end

return M
