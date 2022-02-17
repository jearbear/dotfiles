require("nvim-treesitter.configs").setup({
    ensure_installed = {
        "bash",
        "elixir",
        "go",
        "javascript",
        "json",
        "lua",
        "make",
        "python",
        "regex",
        "rust",
        "typescript",
        "vim",
        "yaml",
    },
    highlight = { enable = true },
    endwise = { enable = true },
})

require("lspfuzzy").setup({
    methods = { "textDocument/references" },
    fzf_preview = {
        "up:80%:+{2}-/2",
    },
})

require("pretty-fold").setup({
    fill_char = "-",
})

require("pretty-fold.preview").setup({
    key = "l",
    border = "single",
})

require("gitlinker").setup({
    opts = {
        add_current_line_on_normal_mode = false,
        print_url = true,
    },
    mappings = "<Leader>gl",
})

require("gitsigns").setup({})

require("diffview").setup({
    use_icons = false,
    enhanced_diff_hl = true,
})

require("Comment").setup({})

require("which-key").setup({
    icons = {
        breadcrumb = "»",
        separator = "->",
        group = "+",
    },
    window = {
        border = "single",
    },
})

require("pairs"):setup({
    enter = {
        -- Need to setup something custom to play nicely with nvim-cmp
        enable_mapping = false,
    },
})

local snippy = require("snippy")
snippy.setup({
    mappings = {
        is = {
            ["<C-l>"] = "expand_or_advance",
            ["<C-h>"] = "previous",
        },
    },
})

local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local cmp = require("cmp")
cmp.setup({
    snippet = {
        expand = function(args)
            snippy.expand_snippet(args.body)
        end,
    },

    mapping = {
        ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
        ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
        ["<C-e>"] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
        }),
        ["<CR>"] = cmp.mapping(function(_)
            if not cmp.confirm({ select = false }) then
                require("pairs.enter").type()
            end
        end),
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif snippy.can_expand_or_advance() then
                snippy.expand_or_advance()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif snippy.can_jump(-1) then
                snippy.previous()
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<C-l>"] = cmp.mapping(function(fallback)
            if snippy.can_expand_or_advance() then
                snippy.expand_or_advance()
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<C-h>"] = cmp.mapping(function(fallback)
            if snippy.can_jump(-1) then
                snippy.previous()
            else
                fallback()
            end
        end, { "i", "s" }),
    },

    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "snippy" },
    }),

    experimental = {
        ghost_text = true,
    },
})

cmp.setup.cmdline("/", {
    sources = {
        { name = "buffer" },
    },
})
