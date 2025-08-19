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
    { "andymass/vim-matchup", dependencies = { "anuvyklack/nvim-keymap-amend" } }, -- more extensive support for matching with `%`
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
    { "linty-org/readline.nvim" }, -- provides functions I use to provide readline bindings in insert and command mode
    { "kylechui/nvim-surround" }, -- manipulate surrounds (works with treesitter unlike mini.surround and highlights selections automatically)

    -- copy pasta
    { "gbprod/substitute.nvim" }, -- mappings to substitute text
    { "gbprod/yanky.nvim" }, -- better handling of yanks (yank rings, auto-formatting)

    -- version control
    { "lewis6991/gitsigns.nvim" }, -- VCS change indicators in the gutter

    -- project navigation + management
    { "stevearc/oil.nvim" }, -- minimal file browser
    { "vim-test/vim-test" }, -- run tests and copy test runner commands
    { "wsdjeg/vim-fetch" }, -- support opening line and column numbers (e.g. foo.bar:13)
    { "jpalardy/vim-slime" }, -- send text to other terminal windows (useful for REPLs)

    -- LSP stuff
    { "neovim/nvim-lspconfig" }, -- defines configs for various LSP servers for me
    { "pmizio/typescript-tools.nvim", dependencies = { "nvim-lua/plenary.nvim" } }, -- better/faster typescript support
    { "folke/neodev.nvim" }, -- setup the Lua LSP for neovim development

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
    { "nvim-treesitter/playground" },
    { "tpope/vim-rsi" },
    { "folke/flash.nvim" },
    { "rafikdraoui/jj-diffconflicts" },
    { "saghen/blink.cmp", version = "1.*" },
})
-- }}}

-- THEME {{{
vim.opt.termguicolors = true

require("catppuccin").setup({
    flavour = "mocha",
    transparent_background = false,
    default_integrations = false,
    integrations = {
        flash = true,
        fzf = true,
        blink_cmp = true,
        nvim_surround = false,
        treesitter = true,
        gitsigns = true,
        render_markdown = true,
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
    custom_highlights = function(colors)
        return {
            Whitespace = { fg = "#313244" },
        }
    end,
})

vim.cmd("colorscheme catppuccin")
-- }}}

-- SETTINGS {{{
vim.opt.mouse = "" -- disable mouse

vim.opt.hidden = true -- allow switching buffers without saving

vim.opt.expandtab = true -- use spaces instead of tabs
vim.opt.shiftwidth = 4 -- use 4 spaces per "tab"
vim.opt.softtabstop = 4 -- use 4 spaces per "tab"

vim.opt.cursorline = true -- highlight the line the cursor is on
vim.opt.scrolloff = 10 -- ensure 10 lines of padding between the cursor and the edges of the window

vim.opt.joinspaces = false -- only insert one space when joining sentences

vim.opt.wrap = true -- enable line wrappping
vim.opt.linebreak = true -- enable line wrapping on word boundaries only
vim.opt.breakindent = true -- indent wrapped lines
vim.opt.showbreak = ".." -- indent wrapped lines with `..`

vim.opt.fillchars:append({ diff = "╱" }) -- prettier filler characters for empty diff blocks

function _G.custom_fold_text()
    local line = vim.fn.getline(vim.v.foldstart)
    local marker = string.rep("{", 3)
    if string.sub(line, -#marker) == marker then
        line = string.sub(line, 0, -4) -- remove fold marker
    end
    return line
end

vim.opt.foldenable = false -- default to open folds
vim.opt.foldopen = { "hor", "jump", "mark", "quickfix", "search", "tag", "undo" } -- always open folds when navigated through
vim.wo.foldnestmax = 1
vim.opt.foldtext = "v:lua.custom_fold_text()"
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
-- vim.opt.completeopt = { "menuone", "noselect", "fuzzy" } -- for mini.completion
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
-- automatically create parent directories as needed when saving files
u.autocmd({ "BufWritePre", "FileWritePre" }, {
    pattern = "*",
    callback = function()
        if vim.bo.filetype ~= "oil" then
            vim.cmd([[silent! call mkdir(expand('<afile>:p:h'), 'p')]])
        end
    end,
    group = u.augroup("MKDIR"),
})

u.autocmd("BufReadPost", {
    desc = "Open file at the last position it was edited earlier",
    group = u.augroup("REOPEN"),
    pattern = "*",
    command = 'silent! normal! g`"zv',
})

-- automatically resize splits
u.autocmd({ "VimResized", "TabEnter" }, {
    pattern = "*",
    command = "wincmd =",
    group = u.augroup("RESIZE"),
})

local lualine = require("lualine")

-- automatically read the file on focus (relies on autoread being set)
u.autocmd({ "FocusGained", "BufEnter" }, {
    pattern = "*",
    callback = function()
        if vim.bo.modified and not vim.bo.readonly and vim.fn.expand("%") ~= "" and vim.bo.buftype == "" then
            vim.cmd([[checktime]])
            lualine.refresh()
        end
    end,
    group = u.augroup("AUTO_READ"),
})

-- automatically write the file on focus lost
u.autocmd({ "BufLeave", "FocusLost" }, {
    callback = function()
        if vim.bo.modified and not vim.bo.readonly and vim.fn.expand("%") ~= "" and vim.bo.buftype == "" then
            vim.cmd([[silent update]])
            lualine.refresh()
        end
    end,
    group = u.augroup("AUTO_WRITE"),
})

u.autocmd({ "BufWritePost" }, {
    pattern = "*",
    callback = lualine.refresh,
    group = u.augroup("WRITE_REFRESH_LUALINE"),
})

-- treat pull request edit messages as markdown
u.autocmd("BufEnter", {
    pattern = "*/PULLREQ_EDITMSG",
    callback = function()
        vim.bo.filetype = "markdown"
    end,
    group = u.augroup("PRS"),
})

-- treat .json.tftpl files as json
u.autocmd({ "BufEnter", "BufNew" }, {
    pattern = "*.json.tftpl",
    callback = function()
        vim.bo.filetype = "json"
    end,
    group = u.augroup("JSON_TFTPL"),
})

-- conveniences for empty buffers and the `q:` buffer
-- u.autocmd({ "BufEnter" }, {
--     pattern = "*",
--     callback = function()
--         if vim.o.filetype ~= "" then
--             return
--         end
--
--         u.map("n", "<CR>", "<CR>", { buffer = true })
--         u.map_c("q", "q", { buffer = true })
--     end,
--     group = u.augroup("NONE"),
-- })
-- }}}

-- MAPPINGS {{{
u.map("", "Y", "y$")
u.map("", "0", "^")

-- u.map({ "n", "v" }, ";", ":")
-- u.map({ "n", "v" }, ":", ";")

-- save and quit huehue
u.map_c("<Leader>w", ":w")
u.map_c("<Leader>W", ":wa")
u.map_c("<Leader>q", ":q")
u.map_c("<Leader>Q", ":qa")
u.map_c("<Leader>x", ":x")
u.map_c("<Leader>X", ":xa")

-- scroll by larger increments
u.map({ "n", "v" }, "<C-d>", "10<C-d>")
u.map({ "n", "v" }, "<C-u>", "10<C-u>")

-- navigate by visual lines when lines are wrapped
u.map({ "n", "v" }, "j", "gj")
u.map({ "n", "v" }, "k", "gk")

-- move selected lines around
u.map("v", "<C-j>", ":m '>+1<CR>gv=gv")
u.map("v", "<C-k>", ":m '<-2<CR>gv=gv")

-- preserve cursor position when joining
u.map("n", "J", "mzJ`z")

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

-- faster access to completions
u.map("i", "<C-o>", "<C-x><C-o>")
u.map("i", "<C-l>", "<C-x><C-l>")

-- faster renaming
u.map("n", "<Leader>r", "*``cgn")
u.map("n", "g<Leader>r", "g*``cgn")

-- faster substitution
u.map("n", "<Leader>s", ":%s/<C-r><C-w>/")
u.map("v", "<Leader>s", '"ay/<C-R>a<CR>``:%s//')

-- load the selection into the seach register
u.map("v", "*", '"ay/<C-R>a<CR>``')

-- the default mapping is insane
u.map("i", "<C-Space>", "<nop>")

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
-- u.map("!", "<C-d>", "<Delete>")
-- u.map("!", "<C-f>", "<Right>")
-- u.map("!", "<C-b>", "<Left>")
u.map("i", "<C-k>", "<C-o>d$")
u.map("!", "<C-BS>", "<C-w>")
-- u.map("i", "<C-e>", "<C-o>A")
--
-- u.map("i", "<C-e>", function()
--     u.close_completion_menu()
--     u.set_cursor_pos(u.line_number(), u.col_number() + 1)
-- end)

-- readline mappings when in select mode (relevant when using snippets)
-- u.map("s", "<BS>", "<BS>i")
-- u.map("s", "<C-d>", "<BS>i")
-- u.map("s", "<C-f>", "<Right>")
-- u.map("s", "<C-b>", "<Left>")

-- edit config files
u.map_c("<Leader>vev", "edit ~/.config/nvim/init.lua")
u.map_c("<Leader>vef", "edit ~/.config/nvim/after/ftplugin")
u.map_c("<Leader>vel", "edit ~/.config/nvim/lua/lsp.lua")
u.map_c("<Leader>vep", "edit ~/.config/nvim/lua/plugins.lua")
u.map_c("<Leader>ves", "edit ~/.config/nvim/snippets")
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

-- don't add search navigation to jumplist
u.map_c("n", "keepjumps normal! n", { silent = true })
u.map_c("N", "keepjumps normal! N", { silent = true })

-- Navigate search results with Tab/S-Tab
u.map("c", "<Tab>", function()
    local cmdtype = vim.fn.getcmdtype()
    if cmdtype == "/" then
        return "<C-g>"
    elseif cmdtype == "?" then
        return "<C-t>"
    else
        return "<C-z>"
    end
end, { expr = true })

u.map("c", "<S-Tab>", function()
    local cmdtype = vim.fn.getcmdtype()
    if cmdtype == "/" then
        return "<C-t>"
    elseif cmdtype == "?" then
        return "<C-g>"
    else
        return "<S-Tab>"
    end
end, { expr = true })

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
        u.system({ "open", url })
    else
        print("Could not get Github URL")
    end
end)
-- }}}

require("statusline")
require("plugins")
require("lsp")
