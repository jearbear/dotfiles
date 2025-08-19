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
        "html",
        "javascript",
        "jinja",
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
        "starlark",
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
    matchup = { enable = true },
    -- we use this just for the library of text objects that it provides, but
    -- the actual selection is handled by mini.ai
    textobjects = { select = { enable = false } },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = false,
            node_incremental = "<CR>",
            scope_incremental = "<C-CR>",
            node_decremental = "<S-CR>",
        },
    },
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

-- nvim-ts-autotag {{{
require("nvim-ts-autotag").setup({
    opts = {
        enable_close = true,
        enable_rename = true,
        enable_close_on_slash = true,
    },
})
-- }}}

-- gitsigns.nvim {{{
local gitsigns = require("gitsigns")
gitsigns.setup({
    on_attach = function(bufnr)
        u.map("n", "<Leader>gp", gitsigns.preview_hunk, { buffer = bufnr })
        u.map("n", "<Leader>gb", gitsigns.blame_line, { buffer = bufnr })
        u.map("n", "<Leader>gs", gitsigns.stage_hunk, { buffer = bufnr })
        u.map("n", "<Leader>gu", gitsigns.reset_hunk, { buffer = bufnr })
        u.map("n", "<C-S-j>", function()
            gitsigns.nav_hunk("next", { wrap = false })
        end, { buffer = bufnr })
        u.map("n", "<C-S-k>", function()
            gitsigns.nav_hunk("prev", { wrap = false })
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

u.map("o", "ah", ":<C-U>Gitsigns select_hunk<CR>")
u.map("x", "ah", ":<C-U>Gitsigns select_hunk<CR>")
u.map("o", "ih", ":<C-U>Gitsigns select_hunk<CR>")
u.map("x", "ih", ":<C-U>Gitsigns select_hunk<CR>")
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
        win_height = 20,
        win_vheight = 20,
        winblend = 0,
        delay_syntax = 100,
        border = "single",
    },
})
-- }}}

-- vim-rsi {{{
vim.g.rsi_no_meta = true
-- }}}

-- fzf-lua {{{
local fzf_lua = require("fzf-lua")
fzf_lua.setup({
    hls = {
        border = "Keyword",
        preview_border = "Keyword",
        header_text = "Error",
        buf_flag_cur = "Error",
        buf_flag_alt = "Constant",
    },
    winopts = {
        height = 0.9,
        width = 0.9,
        -- row = 1,
        border = "single",
        backdrop = 100,
        preview = {
            vertical = "up:75%",
            horizontal = "right:66%",
            layout = "flex",
            flip_columns = 160,
            border = "single",
            winopts = {
                number = true,
            },
            title = true,
            delay = 100,
            scrollbar = false,
        },
        on_create = function()
            -- Fzf ignores autocmds when opening (for some reason) so we need
            -- to explicitly close the nvim-bqf preview window if it's open.
            local qf_win_id = vim.fn.getqflist({ winid = 0 }).winid
            if qf_win_id ~= 0 then
                require("bqf.preview.handler").hideWindow(qf_win_id)
            end
            -- Set mappings to get to the first and last results.
            u.map("t", "<C-S-J>", "<End>", { silent = true, buffer = true })
            u.map("t", "<C-S-K>", "<Home>", { silent = true, buffer = true })
        end,
    },
    -- Use same bindings as FZF in the shell
    keymap = { fzf = {} },
    fzf_opts = {
        ["--tiebreak"] = "chunk", -- prefer continuous matches
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
            ["--with-nth"] = "1,4..", -- hide line numbers
            ["--tiebreak"] = "chunk", -- prefer continuous matches
            ["--history"] = vim.fn.stdpath("data") .. "/fzf-lua-grep-history",
        },
    },
    blines = {
        fzf_opts = {
            ["--tiebreak"] = "chunk",
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
    elseif true then
        fzf_lua.files({})
    else
        fzf_lua.files({ winopts = { preview = { layout = "vertical" } } })
    end
end)
u.map("n", "<Leader>F", fzf_cmd(fzf_lua.git_status, { layout = "vertical" }))
u.map("n", "<Leader>-", function()
    fzf_lua.files({ cmd = "fd --type directory" })
end)
u.map("n", "<Leader>l", fzf_cmd(fzf_lua.buffers, { layout = "vertical" }))
u.map("n", "<Leader>;", fzf_cmd(fzf_lua.blines, { layout = "vertical" }))
u.map("n", "<Leader>:", fzf_cmd(fzf_lua.command_history))
u.map("n", "<Leader>G", fzf_cmd(fzf_lua.lsp_live_workspace_symbols, { history = "live-workspace-symbols" }))
u.map("n", "<Leader>k", fzf_cmd(fzf_lua.lsp_document_symbols, { history = "document-symbols" }))
u.map("n", "<Leader>h", fzf_cmd(fzf_lua.help_tags))
u.map("n", "<Bslash>", fzf_cmd(fzf_lua.live_grep, { layout = "vertical" }))
u.map("n", "<Leader><Bslash>", fzf_cmd(fzf_lua.live_grep_resume, { layout = "vertical" }))
u.map("n", "<Bar>", fzf_cmd(fzf_lua.grep_cword, { layout = "vertical" }))
u.map("v", "<Bar>", fzf_cmd(fzf_lua.grep_visual, { layout = "vertical" }))
u.map("n", "<Leader>o", fzf_cmd(fzf_lua.oldfiles, { layout = "vertical" }))
u.map("n", "<Leader>j", fzf_cmd(fzf_lua.jumps))
u.map("n", "<C-t>", fzf_cmd(fzf_lua.tagstack))
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
    return 'watchexec --restart --exts py,html --clear -- pytest -n0 --snapshot-update' . a:cmd[17:]
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

-- mini.ai {{{
local gen_spec = require("mini.ai").gen_spec
local gen_ai_spec = require("mini.extra").gen_ai_spec
require("mini.ai").setup({
    silent = true,
    custom_textobjects = {
        t = gen_spec.treesitter({ a = "@tag.outer", i = "@tag.inner" }),
        F = gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
        c = gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
        g = gen_ai_spec.buffer(),
        i = gen_ai_spec.indent(),
        n = gen_ai_spec.number(),
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

        [")"] = { action = "close", pair = "()", neigh_pattern = "[^\\]." },
        ["]"] = { action = "close", pair = "[]", neigh_pattern = "[^\\]." },
        ["}"] = { action = "close", pair = "{}", neigh_pattern = "[^\\]." },
        [">"] = { action = "close", pair = "<>", neigh_pattern = "[^\\]." },

        ['"'] = { action = "closeopen", pair = '""', neigh_pattern = "[^\\].", register = { cr = false } },
        ["'"] = { action = "closeopen", pair = "''", neigh_pattern = "[^\\%a].", register = { cr = false } },
        ["`"] = { action = "closeopen", pair = "``", neigh_pattern = "[^\\].", register = { cr = false } },
    },
})
u.map("i", "<C-h>", "v:lua.MiniPairs.bs()", { expr = true, replace_keycodes = false })
-- }}}

-- mini.completion {{{
-- require("mini.completion").setup({
--     delay = { completion = 50, info = 50, signature = 50 },
--     window = {
--         info = { height = 25, width = 80, border = "single" },
--         signature = { height = 25, width = 80, border = "single" },
--     },
--     fallback_action = "<C-x><C-p>",
--     mappings = {
--         force_twostep = "<C-Space>",
--         force_fallback = "<C-p>",
--         scroll_down = "",
--         scroll_up = "",
--     },
--     set_vim_settings = true,
-- })
-- }}}

-- blink.cmp {{{
require("blink.cmp").setup({
    keymap = {
        preset = "default",
        ["<C-space>"] = { "show", "select_and_accept" },
        ["<C-b>"] = {},
        ["<C-f>"] = {},
        ["<C-k>"] = {},
    },
    completion = {
        ghost_text = { enabled = false },
        menu = {
            border = "none",
            draw = {
                columns = {
                    {
                        "kind_icon",
                        "label",
                        "label_description",
                        "source_name",
                        gap = 1,
                    },
                },
                components = {
                    kind_icon = {
                        text = function(ctx)
                            local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
                            return kind_icon
                        end,
                        -- (optional) use highlights from mini.icons
                        highlight = function(ctx)
                            local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                            return hl
                        end,
                    },
                    kind = {
                        -- (optional) use highlights from mini.icons
                        highlight = function(ctx)
                            local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                            return hl
                        end,
                    },
                },
            },
        },
        documentation = { auto_show = true },
        list = {
            selection = {
                preselect = true,
            },
        },
    },
    snippets = { preset = "mini_snippets" },
    sources = { default = { "lsp", "snippets", "buffer" } },
    fuzzy = { implementation = "prefer_rust_with_warning" },
    signature = { enabled = true, window = { show_documentation = false } },
})
-- }}}

-- mini.snippets {{{
local mini_snippets = require("mini.snippets")
mini_snippets.setup({
    snippets = {
        mini_snippets.gen_loader.from_lang(),
    },
    mappings = {
        jump_next = "",
        jump_prev = "",
    },
})

u.map("i", "<C-j>", function()
    if #mini_snippets.expand({ insert = false }) > 0 then
        mini_snippets.expand()
    elseif mini_snippets.session.get() ~= nil then
        mini_snippets.session.jump("next")
    end
end)
-- u.map("i", "<C-k>", function()
--     if mini_snippets.session.get() ~= nil then
--         mini_snippets.session.jump("prev")
--         return ""
--     else
--         return "<C-o>d$"
--     end
-- end, { remap = true })

-- }}}

-- mini.icons {{{
require("mini.icons").setup({
    style = "ascii",
})
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
    move_cursor = false,
    aliases = {
        ["{"] = "}",
        ["<"] = ">",
        ["("] = ")",
        ["["] = "]",
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
        timer = 100,
    },
})

u.map({ "n", "x" }, "y", "<Plug>(YankyYank)")

u.map({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
u.map({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
u.map({ "n" }, "=p", "<Plug>(YankyPutIndentAfterLinewise)")
u.map({ "n" }, "=P", "<Plug>(YankyPutIndentBeforeLinewise)")

u.map("n", "<C-p>", "<Plug>(YankyCycleForward)")
u.map("n", "<C-n>", "<Plug>(YankyCycleBackward)")
-- }}}

-- substitute.nvim {{{
local substitute = require("substitute")
substitute.setup({
    on_substitute = require("yanky.integration").substitute(),
    highlight_substituted_text = {
        timer = 100,
    },
})

u.map("n", "s", function()
    substitute.operator()
end)
u.map("n", "ss", function()
    substitute.line({ modifiers = { "reindent" } })
end)
u.map("x", "s", function()
    substitute.visual()
end)
u.map("n", "S", substitute.eol)
-- }}}

-- neodev.nvim {{{
require("neodev").setup({})
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
vim.g.slime_dont_ask_default = true

u.map("n", "<C-c><C-c>", function()
    if not vim.g.slime_default_config then
        vim.cmd("SlimeSetup")
    end
    u.feed_keys("<C-c>v")
end)
u.map("n", "<C-c>v", "<Plug>SlimeParagraphSend")

u.map("x", "<C-c><C-c>", function()
    if not vim.g.slime_default_config then
        vim.cmd("SlimeSetup")
    end
    u.feed_keys("<C-c>v")
end)
u.map("x", "<C-c>v", "<Plug>SlimeRegionSend")

u.command("SlimeSetup", function()
    vim.g.slime_default_config = {
        listen_on = os.getenv("KITTY_LISTEN_ON"),
        window_id = tonumber(vim.fn.system("kitty @ select-window --self")),
    }
    vim.notify("Slime config set for Kitty", vim.log.levels.INFO)
end, { desc = "Configure vim-slime for Kitty terminal" })
-- }}}

-- nvim-lint {{{
require("lint").linters_by_ft = {
    sh = { "shellcheck" },
    bash = { "shellcheck" },
    python = { "ruff" },
    elixir = { "credo" },
    typescriptreact = { "eslint_d" },
    typescript = { "eslint_d" },
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
        bash = { "shfmt" },
        css = { "prettierd" },
        elixir = {},
        elm = {},
        fish = { "findent" },
        html = { "prettierd" },
        javascript = { "prettierd" },
        javascriptreact = { "prettierd" },
        json = { "prettierd" },
        lua = { "stylua" },
        -- markdown = { "prettierd" },
        python = { "ruff_fix", "ruff_format" },
        sh = { "shfmt" },
        starlark = { "ruff_fix", "ruff_format" },
        terraform = { "terraform_fmt" },
        toml = { "taplo" },
        typescript = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        yaml = { "prettierd" },
    },
    notify_on_error = false,
    format_on_save = {
        lsp_fallback = true,
        timeout_ms = 2000,
        quiet = true,
    },
})
-- }}}

-- oil.nvim {{{
require("oil").setup({
    columns = {},
    keymaps = {
        ["q"] = "actions.close",
        ["<C-v>"] = "actions.select_vsplit",
        ["<C-s>"] = "actions.select_split",
        ["<C-h>"] = false,
    },
    skip_confirm_for_simple_edits = true,
    cleanup_delay_ms = 0,
    lsp_file_methods = {
        enabled = true,
        timeout_ms = 3000,
        autosave_changes = true,
    },
})

u.map_c("-", "Oil")
-- }}}

-- flash.nvim {{{
local flash = require("flash")
flash.setup({
    modes = {
        search = {
            enabled = false,
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

-- lualine.nvim {{{
u.map("n", "<Leader>tr", ":LualineRenameTab ")
-- }}}
