local u = require("utils")

-- packer.nvim {{{
local packer = require("packer")

vim.api.nvim_create_user_command("PS", function(input)
    packer.compile()
    packer.clean()
    packer.install()
    if input.bang then
        packer.update()
    end
end, { bang = true })
-- }}}

-- nvim-treesitter {{{
-- work around compiler issues on Mac OS
require("nvim-treesitter.install").compilers = { "gcc-11" }

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

    textsubjects = {
        enable = true,
        prev_selection = ",",
        keymaps = {
            ["."] = "textsubjects-smart",
            [";"] = "textsubjects-container-outer",
            ["i;"] = "textsubjects-container-inner",
        },
    },
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
        u.map("n", "<Leader>gs", gitsigns.stage_hunk, { buffer = bufnr })
        u.map("n", "<Leader>gS", gitsigns.undo_stage_hunk, { buffer = bufnr })
        u.map("n", "<Leader>gu", gitsigns.reset_hunk, { buffer = bufnr })
        u.map("n", "<Leader>gn", gitsigns.next_hunk, { buffer = bufnr })
        u.map("n", "<Leader>gp", gitsigns.prev_hunk, { buffer = bufnr })
    end,
})
-- }}}

-- diffview.nvim {{{
require("diffview").setup({
    use_icons = false,
    enhanced_diff_hl = true,
})

u.map_c("<Leader>gs", "DiffviewOpen")
u.map_c("<Leader>gd", "DiffviewFileHistory %")
u.map_c("<Leader>gD", "DiffviewFileHistory")
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
local marks = require("marks")
marks.setup({
    default_mappings = true,
    mappings = {
        next = ")",
        prev = "(",
    },
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
        ghost_text = true,
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

cmp.setup.cmdline("/", {
    sources = {
        { name = "buffer" },
    },
})
-- }}}

-- vim-grepper {{{
vim.g.grepper = {
    prompt_text = "$t> ",
    tools = { "rg", "go", "migrations" },
    rg = {
        grepprg = "rg --vimgrep --smart-case --with-filename",
    },
    go = {
        grepprg = "rg --vimgrep --smart-case --with-filename -t go",
    },
    migrations = {
        escape = "\\^$.*+?()[]{}|",
        grepformat = "%f:%l:%c:%m,%f",
        grepprg = "rg --vimgrep --smart-case --with-filename --sortr path -t sql $* ~/code/pipe/backend/migrations",
    },
    stop = 1000,
    prompt_quote = 2, -- populate prompt with single quotes
    searchreg = 1, -- load query into search register (allows hitting `n` to navigate results in quickfix list)
}

u.map_c("<Bslash>", "Grepper")
u.map({ "n", "x" }, "gs", "<Plug>(GrepperOperator)")
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
    grep = {
        rg_glob = true,
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
u.map_c("<Leader>F", "FzfLua git_status")
u.map_c("<Leader>l", "FzfLua buffers")
u.map_c("<Leader>;", "FzfLua blines")
u.map_c("<Leader>:", "FzfLua command_history")
u.map_c("<Leader>G", "FzfLua lsp_live_workspace_symbols")
u.map("n", "<Leader>k", function()
    -- Remove filename from results since it's not useful
    fzf_lua.lsp_document_symbols({ fzf_cli_args = "--with-nth 2.." })
end)
u.map_c("<Leader>h", "FzfLua help_tags")
u.map_c("<Bar>", "FzfLua grep_project")
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
    { sn = "~/.config/nvim/snippets" },
}
vim.g.startify_lists = {
    { type = "dir", header = { "   Latest Edits" } },
    { type = "bookmarks", header = { "   Bookmarks" } },
    { type = "commands", header = { "   Commands" } },
}

u.map_c("<Leader>S", "Startify")
-- }}}

-- vim-matchup {{{
vim.g.matchup_matchparen_offscreen = { method = "popup" }
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
        u.map_c("<Leader>cb", "GitConflictChooseBase", { buffer = 0 })
    end,
    group = u.augroup("GIT_CONFLICT"),
})
-- }}}

-- cybu.nvim {{{
require("cybu").setup({
    position = {
        max_win_height = 7,
    },
    style = {
        path = "relative",
        border = "single",
        padding = 1,
        devicons = {
            enabled = false,
        },
    },
    display_time = 500,
})

u.map("n", "<S-Tab>", "<Plug>(CybuPrev)")
u.map("n", "<Tab>", "<Plug>(CybuNext)")
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
require("nvim-surround").setup({})
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
