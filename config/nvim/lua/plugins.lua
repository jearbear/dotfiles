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

require("gitsigns").setup({})

require("nvim-autopairs").setup({})

require("Comment").setup({})

require("which-key").setup({
    icons = {
        breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
        separator = "->", -- symbol used between a key and it's label
        group = "+", -- symbol prepended to a group
    },
    window = {
        border = "single",
    },
})
