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
        "terraform",
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
    -- we use this just for the library of text objects that it provides, but
    -- the actual selection is handled by mini.ai
    textobjects = { select = { enable = false } },
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

-- tree-sitter-just {{{
require("tree-sitter-just").setup({})
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
        u.map("n", "<C-S-j>", gitsigns.next_hunk, { buffer = bufnr })
        u.map("n", "<C-S-k>", gitsigns.prev_hunk, { buffer = bufnr })
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
            preview_border = "Keyword",
            header_text = "Error",
            buf_flag_cur = "Error",
            buf_flag_alt = "Constant",
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
        fzf_opts = {
            ["--delimiter"] = "[:]",
            ["--with-nth"] = "1,3..",
            ["--nth"] = "2..",
            ["--tiebreak"] = "index",
            ["--history"] = vim.fn.stdpath("data") .. "/fzf-lua-grep-history",
        },
    },
    blines = {
        fzf_opts = {
            ["--delimiter"] = "[:]",
            ["--with-nth"] = "3..",
            ["--tiebreak"] = "index",
        },
    },
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

function! PytestTransform(cmd) abort
    return 'watchexec --restart --exts py --clear -- pytest -n0' . a:cmd[16:]
endfunction

let g:test#python#runner = 'pytest'
let g:test#custom_transformations = {'python': function('PytestTransform')}
let g:test#transformation = 'python'
]])

u.map_c("<Leader>tf", "TestFile")
u.map_c("<Leader>tl", "TestNearest")
u.map_c("<Leader>tT", "TestFile -strategy=kitty")
u.map_c("<Leader>tt", "TestNearest -strategy=kitty")
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

-- mini.ai {{{
require("mini.ai").setup({
    silent = false,
})
-- }}}

-- mini.bufremove {{{
require("mini.bufremove").setup({})

u.map("n", "Q", MiniBufremove.wipeout)
-- }}}

-- mini.align {{{
require("mini.align").setup({})
-- }}}

-- mini.pairs {{{
require("mini.pairs").setup({
    mappings = {
        ["("] = { action = "open", pair = "()", neigh_pattern = "[^\\]." },
        ["["] = { action = "open", pair = "[]", neigh_pattern = "[^\\]." },
        ["{"] = { action = "open", pair = "{}", neigh_pattern = "[^\\]." },
        ["<"] = { action = "open", pair = "<>", neigh_pattern = "[^\\]." },

        [")"] = { action = "close", pair = "()", neigh_pattern = "[^\\]." },
        ["]"] = { action = "close", pair = "[]", neigh_pattern = "[^\\]." },
        ["}"] = { action = "close", pair = "{}", neigh_pattern = "[^\\]." },
        [">"] = { action = "close", pair = "<>", neigh_pattern = "[^\\]." },

        ['"'] = { action = "closeopen", pair = '""', neigh_pattern = "[^\\].", register = { cr = false } },
        ["'"] = { action = "closeopen", pair = "''", neigh_pattern = "[^%a\\].", register = { cr = false } },
        ["`"] = { action = "closeopen", pair = "``", neigh_pattern = "[^\\].", register = { cr = false } },
    },
})
-- }}}

-- mini.completion {{{
require("mini.completion").setup({
    delay = { completion = 0, info = 0, signature = 0 },

    window = {
        info = { border = "single" },
        signature = { border = "single" },
    },

    lsp_completion = {
        source_func = "completefunc",
        auto_setup = true,
    },

    fallback_action = "<C-x><C-n>",

    mappings = {
        force_twostep = "",
        force_fallback = "",
    },

    set_vim_settings = false, -- I've set this on my own
})
-- Copied from VisualNOS
vim.cmd([[highlight MiniCompletionActiveParameter cterm=bold gui=bold guibg=#45475a]])
-- }}}

-- nvim-surround {{{
-- Reasons I prefer this over mini.surround:
-- - supports tags really well
-- - has a mapping to affect the entire line
-- - supports modifying tags
require("nvim-surround").setup({
    keymaps = {
        normal = "<Leader>sa",
        normal_cur = "<Leader>ss",
        visual = "<Leader>sa",
        delete = "<Leader>sd",
        change = "<Leader>sc",
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
u.map("!", "<C-BS>", readline.backward_kill_word)
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
vim.g.slime_python_ipython = true
-- }}}

-- tsc.nvim {{{
require("tsc").setup({})
-- }}}

-- nnn.nvim {{{
require("nnn").setup({
    picker = {
        cmd = "nnn -CReorA",
        width = 0.8,
        height = 0.7,
        xoffset = 0.5,
        yoffset = 0.5,
        border = "single",
    },
})
u.map_c("_", "NnnPicker %:p:h")
-- }}}
