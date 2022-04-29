local u = require("utils")

-- nvim-treesitter {{{
require("nvim-treesitter.configs").setup({
    ensure_installed = {
        "bash",
        "comment",
        "eex",
        "elixir",
        "go",
        "graphql",
        "heex",
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

-- Default to .dotfiles if there is no other git directory
-- See: https://github.com/lewis6991/gitsigns.nvim/issues/397
local jid = vim.fn.jobstart({ "git", "rev-parse", "--git-dir" })
local ret = vim.fn.jobwait({ jid })[1]
if ret > 0 then
    vim.env.GIT_DIR = vim.fn.expand("~/.dotfiles")
    vim.env.GIT_WORK_TREE = vim.fn.expand("~")
end

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
        set_bookmark0 = "m",
        next_bookmark0 = "'",
        prev_bookmark0 = '"',
        delete_bookmark = "M",
        delete_bookmark0 = "dm",
    },
    bookmark_0 = {
        sign = "*",
    },
})

u.map_c("<Leader>j", "BookmarksQFList 0")
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
            if snippy.can_jump(1) then
                snippy.next()
            elseif snippy.can_expand() then
                snippy.expand()
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

-- fzf-lua {{{
local fzf_lua = require("fzf-lua")
fzf_lua.setup({
    winopts = {
        height = 0.80,
        width = 1,
        border = "single",
        hl = {
            border = "Keyword",
        },
        preview = {
            vertical = "up:75%",
            border = "sharp",
            winopts = {
                number = false,
            },
        },
    },
    grep = {
        rg_glob = true,
    },
})

u.map_c("<Leader><Space>", "FzfLua")
u.map("n", "<Leader>f", function()
    if vim.loop.cwd() == vim.fn.expand("~") then
        fzf_lua.git_files({ git_dir = "~/.dotfiles", git_worktree = "~" })
    else
        fzf_lua.files()
    end
end)
u.map_c("<Leader>F", "FzfLua git_status")
u.map_c("<Leader>l", "FzfLua buffers")
u.map_c("<Leader>;", "FzfLua buffer_lines")
u.map_c("<Leader>:", "FzfLua command_history")
u.map_c("<Leader>g", "FzfLua lsp_live_workspace_symbols")
u.map("n", "<Leader>k", function()
    -- Remove filename from results since it's not useful
    fzf_lua.lsp_document_symbols({ fzf_cli_args = "--with-nth 2.." })
end)
u.map_c("<Leader>h", "FzfLua help_tags")
u.map_c("<Bar>", "FzfLua grep_project")
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
