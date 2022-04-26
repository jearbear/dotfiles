local u = require("utils")

-- nvim-treesitter {{{
require("nvim-treesitter.configs").setup({
    ensure_installed = {
        "bash",
        "comment",
        -- "eex",
        -- "elixir", -- TODO: Uncomment once 0.7 fixes performance issues
        "go",
        "graphql",
        -- "heex",
        "javascript",
        "json",
        "lua",
        "make",
        "markdown",
        "python",
        "regex",
        "rust",
        "tsx",
        "typescript",
        "vim",
        "yaml",
    },
    highlight = { enable = true },
    indent = { enable = true },
    endwise = { enable = true },
})
-- }}}

-- stabilize.nvim {{{
-- require("stabilize").setup({})
-- }}}

-- pretty-fold.nvim {{{
require("pretty-fold").setup({
    fill_char = "·",
})

require("pretty-fold.preview").setup({
    key = "l",
    border = "single",
})
-- }}}

-- gitlinker.nvim {{{
require("gitlinker").setup({
    opts = {
        remote = "origin",
        add_current_line_on_normal_mode = false,
        print_url = true,
    },
    mappings = "<Leader>gl",
})
-- }}}

-- gitsigns.nvim {{{
local gitsigns = require("gitsigns")
gitsigns.setup({
    on_attach = function(bufnr)
        u.map("n", "<Leader>gb", gitsigns.blame_line, { buffer = bufnr })
    end,
})
-- }}}

-- diffview.nvim {{{
require("diffview").setup({
    use_icons = false,
    enhanced_diff_hl = true,
})
-- }}}

-- Comment.nvim {{{
require("Comment").setup({})

u.map("n", "<Leader>/", "gcc", { remap = true })
u.map("v", "<Leader>/", "gc", { remap = true })
-- }}}

-- nvim-autopairs {{{
require("nvim-autopairs").setup({
    disable_in_macro = true,
    disable_in_visualblock = true,
})
-- }}}

-- nvim-bqf {{{
require("bqf").setup({
    auto_resize_height = true,
    func_map = {
        ptogglemode = "Z",
        stogglebuf = "`",
        filter = "K",
        filterr = "D",
    },
})
-- }}}

-- marks.nvim {{{
require("marks").setup({
    default_mappings = false,
    mappings = {
        set_bookmark2 = "mm",
        next_bookmark2 = "`",
        prev_bookmark2 = "<S-`>",
        delete_bookmark2 = "dm",
    },
})
-- }}}

-- nvim-snippy {{{
require("snippy").setup({
    mappings = {
        is = {
            ["<C-l>"] = "expand_or_advance",
            ["<C-h>"] = "previous",
        },
    },
})
-- }}}

-- nvim-cmp + friends {{{
local cmp = require("cmp")
local snippy = require("snippy")

cmp.setup({
    preselect = cmp.PreselectMode.None,

    snippet = {
        expand = function(args)
            snippy.expand_snippet(args.body)
        end,
    },

    -- Sorting by kind leads to some weird choices, especially with gopls so we
    -- disable it.
    sorting = {
        priority_weight = 2,
        comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.recently_used,
            -- cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
        },
    },

    mapping = {
        ["<C-l>"] = cmp.mapping(function(fallback)
            if snippy.can_expand_or_advance() then
                snippy.expand_or_advance()
            elseif cmp.visible() then
                cmp.confirm()
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
        ["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }), { "i", "c" }),
        ["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }), { "i", "c" }),
    },

    sources = cmp.config.sources({
        { name = "nvim_lsp_signature_help" },
    }, {
        { name = "nvim_lsp" },
        { name = "snippy" },
    }),

    experimental = {
        ghost_text = true,
    },
})

-- properly insert braces after completing functions
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))

cmp.setup.cmdline("/", {
    sources = {
        { name = "buffer" },
    },
})
-- }}}

-- vim-grepper {{{
vim.g.grepper = {
    prompt_text = "$t> ",
    tools = { "rg" },
    stop = 1000,
    prompt_quote = 2, -- populate prompt with single quotes
    searchreg = 1, -- load query into search register (allows hitting `n` to navigate results in quickfix list)
}

u.map_c("<Bslash>", "Grepper")
u.map({ "n", "x" }, "gs", "<Plug>(GrepperOperator)")
-- }}}

-- targets.vim {{{
vim.g.targets_seekRanges = "cc cr cb cB lc ac Ac" -- ranges on the cursor
    .. " lr" -- range around the cursor, fully contained on the same line
    .. " rr" -- range ahead of the cursor, fully contained on the same line
    .. " lb ar ab lB Ar aB Ab AB" -- ranges around the cursor, multiline
    .. " ll" -- ranges behind the cursor, fully contained on the same line
-- }}}

-- vim-rsi {{{
vim.g.rsi_no_meta = true
-- }}}

-- fzf.vim {{{
vim.g.fzf_layout = { window = { width = 0.95, height = 0.95, border = "sharp" } }
vim.g.fzf_action = {
    ["ctrl-t"] = "tab split",
    ["ctrl-s"] = "split",
    ["ctrl-v"] = "vsplit",
}
vim.g.fzf_preview_window = { "up:80%,border-sharp", "ctrl-/" }

u.map_c("<Leader>f", "Files")
u.map_c("<Leader>F", "GFiles?")
u.map_c("<Leader>l", "Buffers")
u.map_c("<Leader>;", "BLines")
u.map_c("<Leader>:", "History:")
u.map_c("<Leader>k", "BTags")
u.map_c("<Leader>h", "Help")
-- u.map_c("<Leader>m", "Marks")
u.map_c("<Bar>", "Rg")
-- }}}

-- vim-yoink {{{
vim.g.yoinkAutoFormatPaste = true
vim.g.yoinkIncludeDeleteOperations = true

u.map("n", "<C-n>", "<Plug>(YoinkPostPasteSwapForward)")
u.map("n", "<C-p>", "<Plug>(YoinkPostPasteSwapBack)")

u.map("n", "P", "<Plug>(YoinkPaste_P)")
u.map("n", "p", "<Plug>(YoinkPaste_p)")

u.map("n", "[y", "<Plug>(YoinkRotateBack)")
u.map("n", "]y", "<Plug>(YoinkRotateForward)")

u.map({ "n", "x" }, "y", "<Plug>(YoinkYankPreserveCursorPosition)")

u.map("n", "<C-t>", "<Plug>(YoinkPostPasteToggleFormat)")
-- }}}

-- vim-subversive {{{
u.map("n", "S", "<Plug>(SubversiveSubstituteToEndOfLine)")
u.map({ "n", "x" }, "s", "<Plug>(SubversiveSubstitute)")
u.map("n", "ss", "<Plug>(SubversiveSubstituteLine)")
u.map("x", "P", "<Plug>(SubversiveSubstitute)")
u.map("x", "p", "<Plug>(SubversiveSubstitute)")
-- }}}

-- vim-bbye {{{
u.map_c("Q", "Bwipeout")
-- }}}

-- vim-startify {{{
vim.g.startify_change_to_dir = false
vim.g.startify_relative_path = true
vim.g.startify_session_delete_buffers = true
vim.g.startify_session_persistence = true
vim.g.startify_update_oldfiles = true
vim.g.startify_session_dir = "~/.config/nvim/sessions"

vim.g.startify_custom_header = {}

vim.g.startify_commands = {}
vim.g.startify_bookmarks = {
    { dv = "~/.config/nvim" },
    { sn = "~/snippets.md" },
}
vim.g.startify_lists = {
    { type = "dir", header = { "   Latest Edits" } },
    { type = "bookmarks", header = { "   Bookmarks" } },
    { type = "commands", header = { "   Commands" } },
}

u.map_c("<Leader>S", "Startify")
u.map_c("<Leader>sc", "SClose")
u.map("n", "<Leader>sd", function()
    vim.cmd("SDelete!")
    vim.cmd("SClose")
end)
-- }}}

-- vim-matchup {{{
vim.g.matchup_matchparen_offscreen = { method = "popup" }
-- }}}

-- diffview.nvim {{{
u.map_c("<Leader>gd", "DiffviewFileHistory")
-- }}}

-- vim-test {{{
vim.cmd([[
function! CopyStrategy(cmd) range
    let @+ = a:cmd
    echo a:cmd
endfunction

let g:test#custom_strategies = {'copy': function('CopyStrategy')}
let g:test#strategy = 'copy'
]])

u.map_c("<Leader>tf", "TestFile")
u.map_c("<Leader>tl", "TestNearest")
u.map_c("<Leader>tt", "TestNearest -strategy=basic")
-- }}}

-- harpoon {{{
require("harpoon").setup({
    global_settings = {
        mark_branch = true,
    },
})

local harpoon_mark = require("harpoon.mark")
local harpoon_ui = require("harpoon.ui")

u.map("n", "<Leader>m", harpoon_mark.add_file)
u.map("n", "<Leader>j", harpoon_ui.toggle_quick_menu)
u.map("n", "<Tab>", harpoon_ui.nav_next)
u.map("n", "<S-Tab>", harpoon_ui.nav_prev)
-- }}}
