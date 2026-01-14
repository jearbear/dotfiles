local u = require("utils")

-- ENV VARIABLES {{{
vim.env.VIM_FILES = vim.fn.expand("~/.config/nvim")
-- }}}

-- LEADER KEYS {{{
vim.g.mapleader = " "
vim.g.maplocalleader = " "
-- }}}

-- PLUGINS {{{
-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    -- UI
    { "catppuccin/nvim", name = "catppuccin" }, -- theme
    { "kevinhwang91/nvim-bqf" }, -- enhanced qflist (previews FZF integration)
    { "nvim-lualine/lualine.nvim" }, -- statusline

    -- tree-sitter
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
    { "nvim-treesitter/nvim-treesitter-textobjects" }, -- provides treesitter-powered text objects
    { "nvim-treesitter/nvim-treesitter-context" }, -- provide context into where you are
    { "windwp/nvim-ts-autotag" }, -- automatically close tags
    { "RRethy/nvim-treesitter-endwise" }, -- automatically close everything else
    { "Wansmer/treesj" }, -- treesitter-powered splits and joins

    -- mappings
    -- { "kylechui/nvim-surround" }, -- manipulate surrounds (works with treesitter unlike mini.surround and highlights selections automatically)

    -- copy pasta
    { "gbprod/substitute.nvim" }, -- mappings to substitute text
    { "gbprod/yanky.nvim" }, -- better handling of yanks (yank rings, auto-formatting)

    -- version control
    { "lewis6991/gitsigns.nvim" }, -- VCS change indicators in the gutter

    -- project navigation + management
    { "stevearc/oil.nvim" }, -- minimal file browser
    { "wsdjeg/vim-fetch" }, -- support opening line and column numbers (e.g. foo.bar:13)

    -- linting + formatting
    { "mfussenegger/nvim-lint" }, -- integrate linters that aren't provided by LSPs
    { "stevearc/conform.nvim" }, -- integrate formatters that aren't provided by LSPs

    -- language support for those not covered by tree-sitter
    { "fladson/vim-kitty" },

    -- fzf
    { "ibhagwan/fzf-lua", branch = "main" },

    -- mini
    { "echasnovski/mini.nvim" }, -- used for mini.bufremove, mini.ai (enhanced text objects), mini.align

    -- trying out
    -- { "saghen/blink.cmp", version = "1.*" },
    { "dmtrKovalenko/fold-imports.nvim" },
})
-- }}}

-- THEME {{{
vim.opt.termguicolors = true

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

vim.cmd("colorscheme catppuccin")

local set_hl = function(group, options)
    vim.api.nvim_set_hl(0, group, options)
end

local colors = require("catppuccin.palettes").get_palette("mocha")
for _, group in ipairs(vim.fn.getcompletion("@", "highlight")) do
    set_hl(group, {})
end

set_hl("Whitespace", { fg = colors.surface0 })
set_hl("@comment", { fg = colors.overlay0 })

set_hl("@string", { fg = colors.green })

set_hl("@keyword", { fg = colors.mauve })
set_hl("@keyword.conditional", { fg = colors.mauve })
set_hl("@keyword.conditional.ternary", { fg = colors.mauve })
set_hl("@keyword.coroutine", { fg = colors.mauve })
set_hl("@keyword.debug", { fg = colors.mauve })
set_hl("@keyword.directive", { fg = colors.mauve })
set_hl("@keyword.directive.define", { fg = colors.mauve })
set_hl("@keyword.exception", { fg = colors.mauve })
set_hl("@keyword.function", { fg = colors.mauve })
set_hl("@keyword.import", { fg = colors.mauve })
set_hl("@keyword.modifier", { fg = colors.mauve })
set_hl("@keyword.operator", { fg = colors.mauve })
set_hl("@keyword.repeat", { fg = colors.mauve })
set_hl("@keyword.return", { fg = colors.mauve })
set_hl("@keyword.type", { fg = colors.mauve })

set_hl("@boolean", { fg = colors.peach })
set_hl("@number", { fg = colors.peach })
set_hl("@number.float", { fg = colors.peach })
set_hl("@constant.builtin", { fg = colors.peach })
set_hl("@operator", { fg = colors.red })

set_hl("@function", { fg = colors.lavender })
set_hl("@type.builtin", { fg = colors.lavender })
set_hl("@type", { fg = colors.lavender })

set_hl("@punctuation.delimiter", { fg = colors.overlay1 })
set_hl("@punctuation.bracket", { fg = colors.overlay1 })
set_hl("@punctuation.special", { fg = colors.peach })

set_hl("@markup.strong", { bold = true })
set_hl("@markup.italic", { italic = true })
set_hl("@markup.strikethrough", { strikethrough = true })
set_hl("@markup.underline", { underline = true })
set_hl("@markup.heading.markdown", { bold = true })
set_hl("@markup.heading.1.markdown", { fg = colors.red })
set_hl("@markup.heading.2.markdown", { fg = colors.peach })
set_hl("@markup.heading.3.markdown", { fg = colors.yellow })
set_hl("@markup.heading.4.markdown", { fg = colors.mauve })
set_hl("@markup.heading.5.markdown", { fg = colors.mauve })
set_hl("@markup.heading.6.markdown", { fg = colors.mauve })
set_hl("@markup.link", { fg = colors.blue })
set_hl("@markup.list", { fg = colors.peach })
set_hl("@markup.list.checked", { fg = colors.peach })
set_hl("@markup.list.unchecked", { fg = colors.peach })
-- }}}

-- SETTINGS {{{
vim.opt.mouse = "" -- disable mouse

vim.opt.hidden = true -- allow switching buffers without saving

vim.opt.expandtab = true -- use spaces instead of tabs
vim.opt.shiftwidth = 4 -- use 4 spaces per "tab"
vim.opt.softtabstop = 4 -- use 4 spaces per "tab"

-- vim.opt.guicursor = "" -- I like the vibe of the OG cursors
vim.opt.cursorline = true -- highlight the line the cursor is on
vim.opt.scrolloff = 999 -- ensure 999 lines of padding between the cursor and the edges of the window

vim.opt.joinspaces = false -- only insert one space when joining sentences

vim.opt.wrap = true -- enable line wrappping
vim.opt.linebreak = true -- enable line wrapping on word boundaries only
vim.opt.breakindent = true -- indent wrapped lines
vim.opt.showbreak = ".." -- indent wrapped lines with `..`

vim.opt.fillchars:append({ diff = " " }) -- prettier filler characters for empty diff blocks

vim.opt.foldenable = false -- default to open folds
vim.opt.foldopen = { "hor", "jump", "mark", "quickfix", "search", "tag", "undo" } -- always open folds when navigated through
vim.wo.foldnestmax = 1
vim.opt.fillchars:append({ fold = " " })

vim.opt.conceallevel = 2 -- hide concealed text

vim.opt.incsearch = true -- jump to search results as you type
vim.opt.hlsearch = true -- highlight search results
vim.opt.ignorecase = true -- perform case-insensitive search and replace
vim.opt.smartcase = true -- override `ignorecase` if capital letters are involved

vim.opt.gdefault = true -- default to global (within the line) substitution

vim.opt.splitbelow = true -- default to opening splits below the current buffer
vim.opt.splitright = true -- default to opening splits ot the right of the current buffer
vim.opt.equalalways = true -- default to equalizing all windows when splits are created and closed

vim.opt.showmode = false -- don't show the mode below the status line

vim.opt.lazyredraw = true -- macros are really slow without this

vim.opt.virtualedit = "block" -- allow the cursor to move off the end of the line in visual block mode

vim.opt.suffixes:append({ ",", "," }) -- during completion, if prefixes are the same, prefer files with suffixes (e.g. I don't care about binaries)

vim.opt.wildignore:append({ -- ignore these files and directories during completion
    "*.pyc",
    "*.swp",
    "*.lock",
    "*.min.js",
    "*.min.css",
    "tags",
    "*/tmp/*",
    "*/target/*",
    "*/venv/*",
    "*/vendor/*",
    "*/elm-stuff/*",
    "*/bazel*/*",
    "*/build/*",
})
vim.opt.wildmenu = true -- show all command mode completion options in a menu
vim.opt.wildignorecase = true -- perform case-insensitive completion of files in command mode
vim.opt.wildmode = { "full", "full" } -- complete the entire result in command mode

vim.opt.winborder = "single"

vim.opt.shortmess:append("c") -- don't show messages when performing completion
vim.opt.shortmess:append("I") -- don't show vim start screen

-- vim.opt.completeopt = { "menu", "menuone", "popup" } -- when completing, show a menu even if there is only one result
vim.opt.completeopt = { "menu", "menuone", "fuzzy", "popup" }
vim.opt.complete = { ".", "w", "b", "f" } -- source keyword and line completions from current buffer, open windows, other loaded buffers, and buffer names

vim.opt.pumheight = 10 -- limit the number of completion results to show at a time

vim.opt.signcolumn = "yes"

vim.opt.showtabline = 0 -- disable the tab line (in favor of lualine's)

vim.opt.dictionary:append("/usr/share/dict/words") -- use this for keyword completion (<C-x><C-k>)

vim.opt.isfname:remove(":") -- don't consider `:` as part of the filename to allow jumping to filename:linenum

-- store backup files in their own directory
vim.fn.mkdir(vim.env.VIM_FILES .. "/.backup//", "p")
vim.opt.backupdir = (vim.env.VIM_FILES .. "/.backup//")

-- enable undo files and store them in their own directory
vim.fn.mkdir(vim.env.VIM_FILES .. "/.undo//", "p")
vim.opt.undofile = true
vim.opt.undodir = (vim.env.VIM_FILES .. "/.undo//")

vim.opt.swapfile = false -- disable swap files since they tend to be more annoying than not

vim.g.is_bash = true -- default to bash filetype when `ft=sh`

vim.g.ttimeout = false

vim.opt.matchpairs:append("<:>") -- support <,> matching

-- use ripgrep for `grep` command
vim.opt.grepprg = "rg --vimgrep --smart-case --hidden --sort path"
vim.opt.grepformat = "%f:%l:%c:%m"

u.command("Grep", function(input)
    vim.cmd("silent grep! " .. input.args)
    if not vim.tbl_isempty(vim.fn.getqflist()) then
        vim.cmd("copen")
    else
        vim.notify("No results found!")
    end
end, { nargs = "+", complete = "file" })
-- }}}

-- AUTO COMMANDS {{{
-- ghetto indent lines
u.autocmd({ "BufReadPost" }, {
    pattern = "*",
    callback = function()
        local guide = string.rep(" ", vim.bo.shiftwidth - 1)
        vim.opt_local.list = true
        -- repeat enough times to not have to rely on the built-in repeat which
        -- will look off by one
        vim.opt_local.listchars = {
            tab = "> ",
            leadmultispace = " " .. string.rep(guide .. "│", 100),
        }
    end,
})
-- automatically create parent directories as needed when saving files
u.autocmd({ "BufWritePre", "FileWritePre" }, {
    pattern = "*",
    callback = function()
        if vim.bo.filetype ~= "oil" then
            vim.cmd([[silent! call mkdir(expand('<afile>:p:h'), 'p')]])
        end
    end,
})

u.autocmd("BufReadPost", {
    desc = "Open file at the last position it was edited earlier",
    pattern = "*",
    command = 'silent! normal! g`"zv',
})

-- automatically resize splits
u.autocmd({ "VimResized", "TabEnter" }, {
    pattern = "*",
    command = "wincmd =",
})

local lualine = require("lualine")

-- automatically write the file on focus lost
u.autocmd({ "BufLeave", "FocusLost" }, {
    callback = function()
        if vim.bo.modified and not vim.bo.readonly and vim.fn.expand("%") ~= "" and vim.bo.buftype == "" then
            vim.cmd([[silent update]])
            lualine.refresh()
        end
    end,
})

u.autocmd({ "BufWritePost" }, {
    pattern = "*",
    callback = lualine.refresh,
})

-- treat .json.tftpl files as json
u.autocmd({ "BufEnter", "BufNew" }, {
    pattern = "*.json.tftpl",
    callback = function()
        vim.bo.filetype = "json"
    end,
})
-- }}}

-- MAPPINGS {{{
u.map("", "Y", "y$")
u.map("", "0", "^")
u.map({ "n", "o", "v" }, "<C-f>", "%", { remap = true })

-- save and quit huehue
u.map_c("<Leader>w", ":w")
u.map_c("<Leader>W", ":wa")
u.map_c("<Leader>q", ":q")
u.map_c("<Leader>Q", ":qa!")
u.map_c("<Leader>x", ":x")
u.map_c("<Leader>X", ":xa")

-- scroll by larger increments
u.map({ "n", "v" }, "<C-d>", "10<C-d>")
u.map({ "n", "v" }, "<C-u>", "10<C-u>")

-- navigate by visual lines when lines are wrapped
u.map({ "n", "v" }, "j", "gj")
u.map({ "n", "v" }, "k", "gk")

-- better ^,$ mappings
u.map({ "n", "o", "v" }, "H", "^")
u.map({ "n", "o", "v" }, "L", "$")

-- preserve cursor position when joining
-- u.map("n", "J", "mzJ`z")

-- insert blank lines
u.map("n", "<CR>", "]<Space>", { remap = true })
u.map("n", "<S-CR>", "[<Space>", { remap = true })

-- don't add motions from { or } to the jumplist
u.map_c("}", 'execute "keepjumps norm! " . v:count1 . "}"')
u.map_c("{", 'execute "keepjumps norm! " . v:count1 . "{"')

-- buffer/tab navigation
u.map("n", "<BS>", "<C-^>")
u.map("n", "<C-h>", "<C-^>")
u.map_c("<S-Tab>", "tabp")
u.map_c("<Tab>", "tabn")
u.map_c("<Leader>te", "tabe %")
u.map_c("<Leader>tc", "tabc")

-- more convenient commenting
u.map("n", "<Leader>/", "gcc", { remap = true })
u.map("v", "<Leader>/", "gc", { remap = true })

-- duplicate and comment
function _G.duplicate_and_comment_lines()
    local start_line, end_line = vim.api.nvim_buf_get_mark(0, "[")[1], vim.api.nvim_buf_get_mark(0, "]")[1]
    -- NOTE: `nvim_buf_get_mark()` is 1-indexed, but `nvim_buf_get_lines()` is 0-indexed. Adjust accordingly.
    local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
    -- Store cursor position because it might move when commenting out the lines.
    local cursor = vim.api.nvim_win_get_cursor(0)
    -- Comment out the selection using the builtin gc operator.
    vim.cmd.normal({ "gcc", range = { start_line, end_line } })
    -- Append a duplicate of the selected lines to the end of selection.
    vim.api.nvim_buf_set_lines(0, end_line, end_line, false, lines)
    -- Move cursor to the start of the duplicate lines.
    vim.api.nvim_win_set_cursor(0, { end_line + 1, cursor[2] })
end
u.map({ "n" }, "<Leader>?", function()
    vim.opt.operatorfunc = "v:lua.duplicate_and_comment_lines"
    return "g@l"
end, { expr = true })
u.map({ "x" }, "<Leader>?", function()
    vim.opt.operatorfunc = "v:lua.duplicate_and_comment_lines"
    return "g@"
end, { expr = true })

-- faster access to completions
u.map("i", "<C-o>", "<C-x><C-o>")
u.map("i", "<C-l>", "<C-x><C-l>")

-- the default mapping is insane, overriden if LSP is active
u.map("i", "<C-Space>", "<nop>")

-- dot-repeatable replace actions
u.map("n", "<Leader>r", "*``cgn")
u.map("n", "g<Leader>r", "g*``cgn") -- w/o word boundaries
u.map("v", "<Leader>r", function()
    vim.cmd([[normal! "vy]])
    vim.fn.setreg("/", [[\V]] .. vim.fn.getreg("v"))
    u.feed_keys("cgn")
end)

-- faster substitution
u.map("n", "<Leader>s", ":%s/<C-r><C-w>/")
u.map("v", "<Leader>s", '"ay/<C-R>a<CR>``:%s//')

-- load the selection into the seach register
u.map("v", "*", function()
    vim.cmd([[normal! "vy]])
    vim.fn.setreg("/", vim.fn.getreg("v"))
end)

-- yank/paste to/from system clipboard
-- (recursive mappings are intentionally used to preserve the benefits of
-- preserving cursor position provided by yanky.nvim)
u.map({ "n", "x" }, "<Leader>d", '"+d', { remap = true })
u.map({ "n", "x" }, "<Leader>D", '"+D', { remap = true })
u.map({ "n", "x" }, "<Leader>y", '"+y', { remap = true })
u.map({ "n", "x" }, "<Leader>Y", '"+Y', { remap = true })
u.map({ "n", "x" }, "<Leader>p", '"+p', { remap = true })
u.map({ "n", "x" }, "<Leader>P", '"+P', { remap = true })

-- select content that was just pasted
u.map("n", "gp", "`[v`]")

-- insert at top of file
u.map({ "n" }, "<Leader>O", "ggO")

-- navigate command history using what's already typed in
u.map("c", "<C-p>", "<Up>")
u.map("c", "<C-n>", "<Down>")

-- basic readline mappings ("!" maps both insert and command mode)
u.map("!", "<C-a>", "<Home>")
u.map("!", "<C-e>", "<End>")
u.map("!", "<C-d>", "<Delete>")
u.map("!", "<C-f>", "<Right>")
u.map("!", "<C-b>", "<Left>")
u.map("!", "<C-BS>", "<C-w>")
u.map("i", "<C-k>", "<C-o>d$")

-- indent in insert mode
u.map("i", "<C-.>", "<C-t>")
u.map("i", "<C-,>", "<C-d>")

-- edit config files
u.map_c("<Leader>vev", "edit ~/.config/nvim/init.lua")
u.map_c("<Leader>vef", "edit ~/.config/nvim/after/ftplugin")
u.map_c("<Leader>vel", "edit ~/.config/nvim/lua/lsp.lua")
u.map_c("<Leader>vep", "edit ~/.config/nvim/lua/plugins.lua")
u.map_c("<Leader>ves", "edit ~/.config/nvim/lua/snippets")
u.map_c("<Leader>veu", "edit ~/.config/nvim/lua/utils.lua")

-- toggle qflist
u.map("n", "<Leader>`", function()
    for _, win in pairs(vim.fn.getwininfo()) do
        if win["quickfix"] == 1 then
            vim.cmd("cclose")
            return
        end
    end
    if vim.tbl_isempty(vim.fn.getqflist()) then
        vim.notify("No items in quickfix")
    else
        vim.cmd("copen")
    end
end)

-- these are always typos
u.map("c", "w'", "w")
u.map("n", "<C-w>-", "<C-w>=")

-- https://github.com/neovim/neovim/pull/17932#issue-1188088238
u.map("n", "<C-i>", "<C-i>")

-- only search within selection if a selection is active
u.map("v", "/", "<Esc>/\\%V")
u.map("v", "?", "<Esc>?\\%V")

-- Get Github URL for current file
u.map({ "n", "v" }, "<Leader>gl", function()
    local url = u.get_github_url({ mode = "blob" })
    if url then
        vim.fn.setreg("+", url)
        print(url)
    else
        print("Could not get Github URL")
    end
end)
u.map({ "n", "v" }, "<Leader>go", function()
    local url = u.get_github_url({ mode = "blame" })
    if url then
        u.open_url(url)
    else
        print("Could not get Github URL")
    end
end)
u.map({ "n", "v" }, "<Leader>gB", function()
    local url = u.get_github_pr_url()
    if url then
        u.open_url(url)
    else
        print("Could not get Github PR")
    end
end)

-- slime
u.map("n", "<C-c><C-c>", function()
    u.kitty_send_text(vim.fn.getregion(vim.fn.getpos("'{"), vim.fn.getpos("'}")))
end)
u.map("x", "<C-c><C-c>", function()
    u.kitty_send_text(vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), { type = vim.fn.mode() }))
end)

-- snippets
u.map({ "s" }, "j", "j") -- type instead of navigate in select mode
u.map({ "s" }, "k", "k")

u.map("i", "<C-j>", function()
    if vim.snippet.active({ direction = 1 }) then
        vim.snippet.jump(1)
    else
        u.expand_snippet()
    end
end)

u.map({ "i", "s" }, "<Esc>", function()
    if vim.snippet.active() then
        vim.snippet.stop()
    end
    return "<Esc>"
end, { expr = true })

-- navigate to the beginning/end of TS nodes
u.map("n", "(", function()
    local ts_utils = require("nvim-treesitter.ts_utils")
    local start_node = ts_utils.get_node_at_cursor()
    if not start_node then
        return
    end
    local start_row, start_col = start_node:start()

    local parent_pos = vim.iter((function()
        local node = start_node
        return function()
            node = node:parent()
            return node
        end
    end)())
        :map(function(node)
            local row, col = node:start()
            return { row, col }
        end)
        :find(function(pos)
            return pos[1] ~= start_row or pos[2] ~= start_col
        end)

    if parent_pos then
        vim.api.nvim_win_set_cursor(0, { parent_pos[1] + 1, parent_pos[2] })
    end
end)
u.map("n", ")", function()
    local ts_utils = require("nvim-treesitter.ts_utils")
    local start_node = ts_utils.get_node_at_cursor()
    if not start_node then
        return
    end
    local start_row, start_col = start_node:end_()

    local parent_pos = vim.iter((function()
        local node = start_node
        return function()
            node = node:parent()
            return node
        end
    end)())
        :map(function(node)
            local row, col = node:end_()
            return { row, col }
        end)
        :find(function(pos)
            return pos[1] ~= start_row or pos[2] ~= start_col
        end)

    if parent_pos then
        -- Ignore errors if we somehow attempt to move out of the buffer
        pcall(vim.api.nvim_win_set_cursor, 0, { parent_pos[1] + 1, parent_pos[2] - 1 })
    end
end)
-- }}}

require("statusline")
require("plugins")
require("lsp")
