local u = require("utils")

-- nvim-treesitter {{{
-- work around compiler issues on Mac OS
require("nvim-treesitter.install").compilers = { "gcc-11" }

require("nvim-treesitter.configs").setup({
    ensure_installed = {
        "bash",
        "css",
        "eex",
        "elixir",
        "go",
        "graphql",
        "heex",
        "javascript",
        "json",
        "jsonnet",
        "just",
        "lua",
        "make",
        "markdown",
        "markdown_inline",
        "python",
        "regex",
        "rust",
        "surface",
        "terraform",
        "tsx",
        "typescript",
        "vim",
        "yaml",
        -- "sql", -- this doesn't work very well at the moment
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
    max_lines = 5,
    trim_scope = "inner",
})

vim.cmd([[highlight TreesitterContext guibg=#313244]])
vim.cmd([[highlight TreesitterContextBottom guibg=#313244 guisp=#51576d gui=underline]])

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
        u.map("n", "<Leader>gp", gitsigns.preview_hunk, { buffer = bufnr })
        u.map("n", "<Leader>gb", gitsigns.blame_line, { buffer = bufnr })
        u.map("n", "<Leader>gs", gitsigns.stage_hunk, { buffer = bufnr })
        u.map("n", "<Leader>gS", gitsigns.undo_stage_hunk, { buffer = bufnr })
        u.map("n", "<Leader>gu", gitsigns.reset_hunk, { buffer = bufnr })
        u.map("n", "<C-S-j>", function()
            gitsigns.next_hunk({ wrap = false })
        end, { buffer = bufnr })
        u.map("n", "<C-S-k>", function()
            gitsigns.prev_hunk({ wrap = false })
        end, { buffer = bufnr })
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
        filterr = "R",
    },
    preview = {
        auto_preview = true,
        win_height = 999,
        win_vheight = 999,
        winblend = 0,
        delay_syntax = 100,
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
            preview_border = "Keyword",
            header_text = "Error",
            buf_flag_cur = "Error",
            buf_flag_alt = "Constant",
        },
        preview = {
            vertical = "up:75%",
            horizontal = "right:66%",
            layout = "flex",
            flip_columns = 160,
            border = "sharp",
            winopts = {
                number = true,
            },
            title = false,
            delay = 100,
            scrollbar = false,
        },
    },
    files = {
        fzf_opts = {
            ["--history"] = vim.fn.stdpath("data") .. "/fzf-lua-files-history",
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
            ["--history"] = vim.fn.stdpath("data") .. "/fzf-lua-blines-history",
        },
    },
})

local fzf_cmd = function(fn, params)
    params = params or {}
    local layout = params.layout or nil
    local history = params.history or nil

    return function()
        fn({
            winopts = layout and { preview = { layout = layout } } or {},
            fzf_opts = history and { ["--history"] = vim.fn.stdpath("data") .. "/fzf-lua-" .. history .. "-history" }
                or {},
        })
    end
end

u.map_c("<Leader><Leader>", "FzfLua")
u.map("n", "<Leader>f", function()
    if vim.loop.cwd() == vim.fn.expand("~") then
        fzf_lua.git_files({
            git_dir = "~/.dotfiles",
            git_worktree = "~",
            winopts = { preview = { layout = "vertical" } },
        })
    else
        fzf_lua.files({ winopts = { preview = { layout = "vertical" } } })
    end
end)
u.map("n", "<Leader>F", fzf_cmd(fzf_lua.git_status, { layout = "vertical" }))
u.map("n", "<Leader>l", fzf_cmd(fzf_lua.buffers, { layout = "vertical" }))
u.map("n", "<Leader>;", fzf_cmd(fzf_lua.blines, { layout = "vertical" }))
u.map("n", "<Leader>:", fzf_cmd(fzf_lua.command_history))
u.map("n", "<Leader>G", fzf_cmd(fzf_lua.lsp_live_workspace_symbols, { history = "live-workspace-symbols" }))
u.map("n", "<Leader>k", fzf_cmd(fzf_lua.lsp_document_symbols, { history = "document-symbols" }))
u.map("n", "<Leader>h", fzf_cmd(fzf_lua.help_tags))
u.map("n", "<Bslash>", fzf_cmd(fzf_lua.live_grep_native, { layout = "vertical" }))
u.map("n", "<Leader><Bslash>", fzf_cmd(fzf_lua.live_grep_resume, { layout = "vertical" }))
u.map("n", "<Bar>", fzf_cmd(fzf_lua.grep_cword, { layout = "vertical" }))
u.map("v", "<Bar>", fzf_cmd(fzf_lua.grep_visual, { layout = "vertical" }))
u.map("n", "<Leader>o", fzf_cmd(fzf_lua.oldfiles, { layout = "vertical" }))
u.map("n", "<Leader>j", fzf_cmd(fzf_lua.jumps))
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
    return 'watchexec --restart --exts py --clear -- pytest -n0' . a:cmd[17:]
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

-- git-conflict.nvim {{{
require("git-conflict").setup({
    default_mappings = false,
    disable_diagnostics = true,
})

u.autocmd("User", {
    pattern = "GitConflictDetected",
    callback = function()
        vim.notify("Conflicts detected! Enabling git conflict mappings...")

        u.map_c("[n", "GitConflictPrevConflict", { buffer = true })
        u.map_c("]n", "GitConflictNextConflict", { buffer = true })
        u.map_c("<Leader>co", "GitConflictChooseOurs", { buffer = true })
        u.map_c("<Leader>ct", "GitConflictChooseTheirs", { buffer = true })
        u.map_c("<Leader>cb", "GitConflictChooseBoth", { buffer = true })
        u.map_c("<Leader>cB", "GitConflictChooseBase", { buffer = true })
    end,
    group = u.augroup("GIT_CONFLICT"),
})

u.map_c("<Leader>cq", "GitConflictListQf", { desc = "Load git conflicts into the quickfix" })
-- }}}

-- mini.ai {{{
local gen_ai_spec = require("mini.extra").gen_ai_spec
require("mini.ai").setup({
    silent = true,
    custom_textobjects = {
        g = gen_ai_spec.buffer(),
        i = gen_ai_spec.indent(),
        N = gen_ai_spec.number(),
    },
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
-- require("mini.completion").setup({
--     delay = { completion = 0, info = 0, signature = 0 },
--
--     window = {
--         info = { border = "single" },
--         signature = { border = "single" },
--     },
--
--     mappings = {
--         force_twostep = "<C-o>",
--     },
-- })
-- }}}

-- nvim-cmp + friends {{{
local cmp = require("cmp")
local snippy = require("snippy")

cmp.setup({
    -- preselect = cmp.PreselectMode.None,
    snippet = {
        expand = function(args)
            snippy.expand_snippet(args.body)
        end,
    },
    window = {
        -- completion = cmp.config.window.bordered({
        --     border = "none",
        --     side_padding = 1,
        -- }),
        documentation = cmp.config.window.bordered({
            border = "single",
            side_padding = 0,
        }),
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

u.map("i", "<C-o>", cmp.complete)

-- when deleting text, enter insert mode instead of bailing out to normal mode
-- u.map("s", "<BS>", "<BS>i")
-- u.map("s", "<C-d>", "<BS>i")
-- u.map("s", "<C-f>", "<Right>")
-- u.map("s", "<C-b>", "<Left>")
-- u.map("s", "<C-o>", "<C-o>o")

-- }}}

-- nvim-surround {{{
-- Reasons I prefer this over mini.surround:
-- - supports tags really well
-- - has a mapping to affect the entire line
-- - supports modifying tags
require("nvim-surround").setup({
    keymaps = {
        normal = "ma",
        normal_cur = "mm",
        visual = "ma",
        delete = "md",
        change = "mc",
    },
})

u.map("n", "M", "ma$", { remap = true })
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

u.map({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
u.map({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")

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

-- treesj {{{
local treesj = require("treesj")
treesj.setup({
    use_default_keymaps = false,
})
u.map("n", "gJ", treesj.join)
u.map("n", "gS", treesj.split)
-- }}}

-- vim-slime {{{
vim.g.slime_target = "kitty"
vim.g.slime_python_ipython = true
-- }}}

-- nvim-lint {{{
require("lint").linters_by_ft = {
    sh = { "shellcheck" },
    bash = { "shellcheck" },
    python = { "ruff" },
    elixir = { "credo" },
}

u.autocmd({ "BufRead", "BufWritePost" }, {
    callback = function()
        require("lint").try_lint()
    end,
    group = u.augroup("LINT"),
})
-- }}}

-- conform.nvim {{{
local conform = require("conform")

require("conform.formatters.stylua").args =
    { "--search-parent-directories", "--indent-type", "Spaces", "--stdin-filepath", "$FILENAME", "-" }

conform.setup({
    formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff_fix", "ruff_format" },
        css = { "prettierd" },
        json = { "prettierd" },
        yaml = { "prettierd" },
        javascript = { "prettierd" },
        javascriptreact = { "prettierd" },
    },
    notify_on_error = false,
    format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
    },
})
-- }}}

-- ultimate-autopair {{{
-- require("ultimate-autopair").setup({})
-- }}}

-- oil.nvim {{{
require("oil").setup({
    columns = {},
    keymaps = {
        ["q"] = "actions.close",
        ["<C-v>"] = "actions.select_vsplit",
        ["<C-s>"] = "actions.select_split",
    },
    skip_confirm_for_simple_edits = true,
})

u.map_c("-", "Oil")
-- }}}

-- flash.nvim {{{
local flash = require("flash")
flash.setup({
    modes = {
        search = {
            -- enabled = false,
            multi_window = false,
        },
        char = { enabled = false },
    },
    highlight = {
        groups = {
            label = "MiniJump2dSpot",
        },
    },
})

u.map({ "n", "x", "o" }, "<C-f>", function()
    flash.jump()
end)
-- }}}
