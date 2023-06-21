local u = require("utils")
local lualine = require("lualine")

-- nvim-treesitter {{{
-- work around compiler issues on Mac OS
require("nvim-treesitter.install").compilers = { "gcc-11" }

require("nvim-treesitter.configs").setup({
    ensure_installed = {
        "bash",
        "eex",
        "elixir",
        "go",
        "graphql",
        "heex",
        "javascript",
        "json",
        "jsonnet",
        "lua",
        "make",
        "markdown",
        "markdown_inline",
        "python",
        "regex",
        "rust",
        -- "sql", -- this doesn't work very well at the moment
        "surface",
        "tsx",
        "typescript",
        "vim",
        "yaml",
    },

    highlight = { enable = true },
    indent = { enable = true },
    endwise = { enable = true },
    autotag = { enable = true },
    matchup = { enable = true },
    incremental_selection = {
        enable = true,
        keymaps = {
            node_incremental = "<CR>",
            node_decremental = "<S-CR>",
        },
    },
    refactor = {
        highlight_definitions = {
            enable = true,
            clear_on_cursor_move = true,
        },
    },
})
-- }}}

-- nvim-treesitter-context {{{
local treesitter_context = require("treesitter-context")
treesitter_context.setup({
    enable = true,
    line_numbers = false,
})

vim.cmd("highlight TreesitterContext guibg=#313244")
vim.cmd("highlight TreesitterContextBottom guibg=#313244 guisp=#51576d gui=underline")

u.map("n", "[c", treesitter_context.go_to_context)
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
        u.map("n", "<Leader>gs", gitsigns.stage_hunk, { buffer = bufnr })
        u.map("n", "<Leader>gS", gitsigns.undo_stage_hunk, { buffer = bufnr })
        u.map("n", "<Leader>gu", gitsigns.reset_hunk, { buffer = bufnr })
        u.map("n", "<Leader>gn", gitsigns.next_hunk, { buffer = bufnr })
        u.map("n", "<Leader>gp", gitsigns.prev_hunk, { buffer = bufnr })
    end,

    signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
    },

    worktrees = {
        {
            toplevel = vim.env.HOME,
            gitdir = vim.env.HOME .. "/.dotfiles",
        },
    },
})
-- }}}

-- nvim-autopairs {{{
require("nvim-autopairs").setup({
    disable_in_macro = true,
    disable_in_visualblock = true,
    -- ignored_next_char = "[^%s]", -- don't auto-pair if next char is not whitespace
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
    preview = {
        win_height = 25,
        win_vheight = 25,
        winblend = 0,
    },
})
-- }}}

-- marks.nvim {{{
require("marks").setup({
    default_mappings = false,
    bookmark_0 = {
        sign = "•",
        virt_text = "<<- bookmark ->>",
    },
    mappings = {
        set_bookmark0 = "m;",
        next_bookmark0 = ")",
        prev_bookmark0 = "(",
        delete_bookmark = "dm",
        delete_bookmark0 = "dM",
    },
    sign_priority = 100,
})
-- }}}

-- nvim-snippy {{{
require("snippy").setup({
    mappings = {
        [{ "i", "s" }] = {
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

    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
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
        ghost_text = false,
    },
})

-- when deleting text, enter insert mode instead of bailing out to normal mode
u.map("s", "<BS>", "<BS>i")
u.map("s", "<C-d>", "<BS>i")
u.map("s", "<C-f>", "<Right>")
u.map("s", "<C-b>", "<Left>")
u.map("s", "<C-o>", "<C-o>o")

-- properly insert braces after completing functions
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))

cmp.setup.cmdline({ "/", "?" }, {
    sources = {
        { name = "buffer", keyword_length = 5 },
    },
})
-- }}}

-- vim-rsi {{{
vim.g.rsi_no_meta = true
-- }}}

-- fzf-lua {{{
local fzf_lua = require("fzf-lua")
fzf_lua.setup({
    winopts = {
        height = 0.80,
        width = 0.90,
        border = "single",
        hl = {
            border = "Keyword",
        },
        preview = {
            vertical = "up:75%",
            layout = "vertical",
            border = "sharp",
            winopts = {
                number = true,
            },
        },
    },
    keymap = {
        fzf = {
            ["ctrl-q"] = "select-all+accept",
        },
    },
    grep = {
        rg_glob = true,
    },

    -- blines = {
    --     previewer = true,
    -- },
})

u.map_c("<Leader><Leader>", "FzfLua")
u.map("n", "<Leader>f", function()
    if vim.loop.cwd() == vim.fn.expand("~") then
        fzf_lua.git_files({ git_dir = "~/.dotfiles", git_worktree = "~" })
    else
        fzf_lua.files()
    end
end)
u.map("n", "<Leader>F", fzf_lua.git_status)
u.map("n", "<Leader>l", fzf_lua.buffers)
u.map("n", "<Leader>;", fzf_lua.blines)
u.map("n", "<Leader>:", fzf_lua.command_history)
u.map("n", "<Leader>G", fzf_lua.lsp_live_workspace_symbols)
u.map("n", "<Leader>k", function()
    -- Remove filename from results since it's not useful
    fzf_lua.lsp_document_symbols({ fzf_cli_args = "--with-nth 2.." })
end)
u.map("n", "<Leader>h", fzf_lua.help_tags)
u.map("n", "<Bslash>", fzf_lua.live_grep_native)
u.map("n", "<Leader><Bslash>", fzf_lua.live_grep_resume)
u.map("n", "<Bar>", fzf_lua.grep_cword)
u.map("v", "<Bar>", fzf_lua.grep_visual)
-- }}}

-- vim-matchup {{{
vim.g.matchup_matchparen_offscreen = {}
-- }}}

-- vim-test {{{
vim.cmd([[
function! CopyStrategy(cmd) range
    let @+ = a:cmd
    echo a:cmd
endfunction

let g:test#custom_strategies = {'copy': function('CopyStrategy')}
let g:test#strategy = 'copy'

function! GoTestTransform(cmd) abort
    return 'be test' . a:cmd[7:]
endfunction

let g:test#custom_transformations = {'go': function('GoTestTransform')}
let g:test#python#runner = 'pytest'
]])

u.map_c("<Leader>tf", "TestFile")
u.map_c("<Leader>tl", "TestNearest")
u.map_c("<Leader>tT", "TestFile -strategy=basic")
u.map_c("<Leader>tt", "TestNearest -strategy=basic")
-- }}}

-- dirbuf.nvim {{{
vim.g.loaded_netrwPlugin = true
vim.g.loaded_netrw = true
-- }}}

-- git-conflict.nvim {{{
require("git-conflict").setup({
    default_mappings = false,
    disable_diagnostics = true,
})

u.autocmd("User", {
    pattern = "GitConflictDetected",
    callback = function()
        vim.notify("Conflicts detected! Enabling git conflict mappings...")

        u.map_c("[n", "GitConflictPrevConflict", { buffer = 0 })
        u.map_c("]n", "GitConflictNextConflict", { buffer = 0 })
        u.map_c("<Leader>co", "GitConflictChooseOurs", { buffer = 0 })
        u.map_c("<Leader>ct", "GitConflictChooseTheirs", { buffer = 0 })
        u.map_c("<Leader>cb", "GitConflictChooseBoth", { buffer = 0 })
        u.map_c("<Leader>cB", "GitConflictChooseBase", { buffer = 0 })
    end,
    group = u.augroup("GIT_CONFLICT"),
})

u.map_c("<Leader>cq", "GitConflictListQf")
-- }}}

-- smart-splits.nvim {{{
local smart_splits = require("smart-splits")
smart_splits.setup({})
-- }}}

-- hydra.nvim {{{
local hydra = require("hydra")

hydra({
    name = "window management",
    mode = "n",

    body = "<Leader><C-w>",
    config = {
        invoke_on_body = true,
        hint = {
            type = "window",
            position = "bottom",
            offset = 1,
            border = "single",
        },
    },
    heads = {
        { "h", "<C-w>h" },
        { "l", "<C-w>l" },
        { "j", "<C-w>j" },
        { "k", "<C-w>k" },

        { "v", "<C-w>v" },
        { "s", "<C-w>s" },

        { "H", "<C-w>H" },
        { "L", "<C-w>L" },
        { "J", "<C-w>J" },
        { "K", "<C-w>K" },

        {
            "<C-h>",
            function()
                smart_splits.resize_left(3)
            end,
        },
        {
            "<C-j>",
            function()
                smart_splits.resize_down(2)
            end,
        },
        {
            "<C-k>",
            function()
                smart_splits.resize_up(2)
            end,
        },
        {
            "<C-l>",
            function()
                smart_splits.resize_right(3)
            end,
        },

        { "=", "<C-w>=" },

        { "q", ":q<CR>" },
    },
})
-- }}}

-- mini.ai {{{
require("mini.ai").setup({})
-- }}}

-- mini.bufremove {{{
require("mini.bufremove").setup({})

u.map("n", "Q", MiniBufremove.wipeout)
-- }}}

-- mini.align {{{
require("mini.align").setup({})
-- }}}

-- nvim-surround {{{
require("nvim-surround").setup({
    keymaps = {
        normal = "ys",
        normal_cur = "yss",
        visual = "S",
        delete = "ds",
        change = "cs",
    },
})
-- }}}

-- yanky.nvim {{{
local yanky = require("yanky")
yanky.setup({
    ring = {
        storage = "memory",
    },
    highlight = {
        timer = 150,
    },
})

u.map({ "n", "x" }, "y", "<Plug>(YankyYank)")

u.map({ "n", "x" }, "p", "<Plug>(YankyPutIndentAfter)")
u.map({ "n", "x" }, "P", "<Plug>(YankyPutIndentBefore)")
u.map({ "n", "x" }, "gp", "<Plug>(YankyPutAfter)")
u.map({ "n", "x" }, "gP", "<Plug>(YankyPutBefore)")

u.map("n", "<C-p>", "<Plug>(YankyCycleForward)")
u.map("n", "<C-n>", "<Plug>(YankyCycleBackward)")
-- }}}

-- substitute.nvim {{{
local substitute = require("substitute")
substitute.setup({
    on_substitute = function(event)
        yanky.init_ring("p", event.register, event.count, event.vmode:match("[vV�]"))
    end,
})

u.map("n", "s", substitute.operator)
u.map("n", "ss", substitute.line)
u.map("x", "s", substitute.visual)
u.map("n", "S", substitute.eol)
-- }}}

-- neodev.nvim {{{
require("neodev").setup({})
-- }}}

-- mini.comment {{{
require("mini.comment").setup({})

u.map("n", "<Leader>/", "gcc", { remap = true })
u.map("v", "<Leader>/", "gc", { remap = true })
-- }}}

-- indent-blankline.nvim {{{
require("indent_blankline").setup({
    show_current_context = true,
    show_current_context_start = true,
})
-- vim.g.indent_blankline_char = ""
vim.g.indent_blankline_filetype = { "python", "yaml", "json", "typescript", "typescriptreact" }
vim.cmd("highlight IndentBlanklineContextChar guifg=#51576d gui=nocombine")
-- vim.cmd("highlight IndentBlanklineContextChar guifg=#313244 gui=nocombine")
vim.cmd("highlight IndentBlanklineContextStart guibg=#313244 guisp=#51576d gui=underline")
-- }}}

-- treesj {{{
local treesj = require("treesj")
treesj.setup({
    use_default_keymaps = false,
})
u.map("n", "gJ", treesj.join)
u.map("n", "gS", treesj.split)
-- }}}

-- readline.nvim {{{
local readline = require("readline")
u.map("!", "<C-k>", readline.kill_line)
u.map("!", "<C-u>", readline.backward_kill_line)
u.map("!", "<M-d>", readline.kill_word)
u.map("!", "<M-BS>", readline.backward_kill_word)
u.map("!", "<C-w>", readline.unix_word_rubout)
u.map("!", "<C-a>", readline.beginning_of_line)
u.map("!", "<C-e>", readline.end_of_line)
u.map("!", "<M-f>", readline.forward_word)
u.map("!", "<M-b>", readline.backward_word)
-- }}}

-- grapple.nvim {{{
local grapple = require("grapple")
grapple.setup({
    scope = grapple.resolvers.git_branch,
    popup_options = {
        width = 150,
    },
})

u.map("n", "<Leader>8", function()
    grapple.toggle()
    lualine.refresh()
end)
u.map("n", "<Leader>j", function()
    grapple.popup_tags()
    lualine.refresh()
end)
u.map("n", "<S-Tab>", grapple.cycle_forward)
u.map("n", "<Tab>", grapple.cycle_backward)
-- }}}

-- vim-slime {{{
vim.g.slime_target = "kitty"
-- }}}
