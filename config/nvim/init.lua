local u = require("utils")

-- ENV VARIABLES {{{
vim.env.VIM_FILES = vim.fn.expand("~/.config/nvim")
-- }}}

-- LEADER KEYS {{{
vim.g.mapleader = " "
vim.g.maplocalleader = " "
-- }}}

-- PLUGINS {{{
local plug = vim.fn["plug#"]

vim.call("plug#begin", "~/.config/nvim/plugged")

-- themes
plug("EdenEast/nightfox.nvim")
plug("catppuccin/nvim", { as = "catppuccin" })
plug("folke/tokyonight.nvim")
plug("rose-pine/neovim")
plug("sainnhe/everforest")
plug("savq/melange")

-- the basics
plug("nvim-lua/plenary.nvim") -- dependency for many lua-based plugins

-- UI
plug("nvim-treesitter/nvim-treesitter", { ["do"] = ":TSUpdate" }) -- better syntax highlighting
plug("anuvyklack/pretty-fold.nvim") -- prettier fold markers and previews
plug("andymass/vim-matchup") -- more extensive support for matching with `%`
plug("nvim-lualine/lualine.nvim") -- statusline
plug("kevinhwang91/nvim-bqf") -- enhanced qflist (previews, FZF integration)

-- mappings
plug("AndrewRadev/splitjoin.vim") -- language-aware splits and joins
plug("numToStr/Comment.nvim") -- key bindings for commenting
plug("tpope/vim-rsi") -- Emacs bindings in command mode
plug("tpope/vim-surround") -- additional mappings to manipulate brackets
plug("tpope/vim-repeat") -- allow `.` to repeate vim-surround actions
plug("tpope/vim-unimpaired") -- mostly use for [<Space> and ]<Space>
plug("wellle/targets.vim") -- additional text objects
plug("moll/vim-bbye") -- delete buffers without closing the window

-- copy pasta
plug("svermeulen/vim-yoink") -- better handling of yanks (yank rings, auto-formatting)
plug("svermeulen/vim-subversive") -- mappings to substitute text

-- version control
plug("ruifm/gitlinker.nvim") -- create links to Github
plug("lewis6991/gitsigns.nvim") -- VCS change indicators in the gutter
plug("sindrets/diffview.nvim") -- git diff across multiple files

-- completion
plug("windwp/nvim-autopairs") -- automatically complete pairs
plug("tpope/vim-endwise") -- automatically close everything else
plug("RRethy/nvim-treesitter-endwise") -- automatically close everything else (tree-sitter)
plug("dcampos/nvim-snippy") -- snippets
plug("hrsh7th/nvim-cmp") -- auto-completion
plug("hrsh7th/cmp-nvim-lsp") -- auto-completion + LSP integration
plug("dcampos/cmp-snippy") -- auto-completion + snippets integration
plug("hrsh7th/cmp-buffer") -- auto-completion when searching (`/` and `?`)
plug("hrsh7th/cmp-nvim-lsp-signature-help") -- show signature information as you type using the completion window

-- project navigation + management
plug("justinmk/vim-dirvish") -- minimal file browser
plug("mhinz/vim-grepper") -- slicker grep support
plug("mhinz/vim-startify") -- start screen + session management
plug("tpope/vim-eunuch") -- unix shell commands in command mode
plug("wsdjeg/vim-fetch") -- support opening line and column numbers (e.g. foo.bar:13)

-- LSP stuff
plug("neovim/nvim-lspconfig") -- defines configs for various LSP servers for me
plug("jose-elias-alvarez/null-ls.nvim") -- integrates gofumports, prettier, etc with the LSP support

-- language support for those not covered by tree-sitter
plug("fladson/vim-kitty")
plug("google/vim-jsonnet")
plug("elixir-editors/vim-elixir")

-- fzf
plug("junegunn/fzf")
plug("junegunn/fzf.vim")

-- trying out
plug("chentau/marks.nvim")

vim.call("plug#end")
-- }}}

-- THEME {{{
vim.opt.termguicolors = true

require("catppuccin").setup({
    -- TODO: the italics settings aren't being respected (https://github.com/catppuccin/nvim/issues/95)
    styles = {
        comments = "italic",
        functions = "NONE",
        keywords = "NONE",
        strings = "italic",
        variables = "NONE",
    },
    integrations = {
        native_lsp = {
            enabled = true,
            virtual_text = {
                errors = "NONE",
                hints = "NONE",
                warnings = "NONE",
                information = "NONE",
            },
            underlines = {
                errors = "underline",
                hints = "underline",
                warnings = "underline",
                information = "underline",
            },
        },
        cmp = true,
        gitsigns = true,
        markdown = true,
    },
})

vim.cmd("colorscheme catppuccin")
-- }}}

-- SETTINGS {{{
vim.opt.lazyredraw = true -- don't redraw the screen while executing macros and registers

vim.opt.hidden = true -- allow switching buffers without saving

vim.opt.expandtab = true -- use spaces instead of tabs
vim.opt.shiftwidth = 4 -- use 4 spaces per "tab"
vim.opt.softtabstop = 4 -- use 4 spaces per "tab"

vim.opt.cursorline = true -- highlight the line the cursor is on
vim.opt.scrolloff = 5 -- ensure 5 lines of padding between the cursor and the edges of the window

vim.opt.joinspaces = false -- only insert one space when joining sentences

vim.opt.wrap = true -- enable line wrappping
vim.opt.linebreak = true -- enable line wrapping on word boundaries only
vim.opt.breakindent = true -- indent wrapped lines
vim.opt.showbreak = ".." -- indent wrapped lines with `..`

-- TODO: checkout other options
vim.opt.fillchars:append({ diff = "╱" }) -- prettier filler characters for empty diff blocks

vim.opt.foldenable = false -- default to open folds
vim.opt.conceallevel = 2 -- hide concealed text

vim.opt.incsearch = true -- jump to search results as you type
vim.opt.hlsearch = false -- don't highlight search results
vim.opt.ignorecase = true -- perform case-insensitive search and replace
vim.opt.smartcase = true -- override `ignorecase` if capital letters are involved

vim.opt.inccommand = "nosplit" -- display incremental results of substitution commands in the buffer

vim.opt.gdefault = true -- default to global (within the line) substitution

vim.opt.splitbelow = true -- default to opening splits below the current buffer
vim.opt.splitright = true -- default to opening splits ot the right of the current buffer

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

vim.opt.shortmess:append("c") -- don't show messages when performing completion
vim.opt.completeopt = { "menu", "menuone" } -- when completing, show a menu even if there is only one result

vim.opt.showtabline = 0 -- disable the tab line (in favor of lualine's)

vim.opt.dictionary:append("/usr/share/dict/words") -- use this for keyword completion (<C-x><C-k>)

vim.opt.isfname:remove(":") -- don't consider `:` as part of the filename to allow jumping to filename:linenum

-- store backup files in their own directory
vim.fn.mkdir(vim.env.VIM_FILES .. "/backup//", "p")
vim.opt.backupdir = (vim.env.VIM_FILES .. "/backup//")

-- enable undo files and store them in their own directory
vim.fn.mkdir(vim.env.VIM_FILES .. "/undo//", "p")
vim.opt.undofile = true
vim.opt.undodir = (vim.env.VIM_FILES .. "/undo//")

vim.opt.swapfile = false -- disable swap files since they tend to be more annoying than not

vim.g.is_bash = true -- default to bash filetype when `ft=sh`

vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
})
-- }}}

-- AUTO COMMANDS {{{
-- turn on search highlighting when midsearch and disable when done
vim.cmd([[
augroup HL_SEARCH
    autocmd!
    autocmd CmdlineEnter /,\? setlocal hlsearch
    autocmd CmdlineLeave /,\? setlocal nohlsearch
augroup END
]])

-- automatically create parent directories as needed when saving files
vim.cmd([[
augroup MKDIR
    autocmd!
    autocmd BufWritePre,FileWritePre * silent! call mkdir(expand('<afile>:p:h'), 'p')
augroup END
]])

-- check if the file has been updated when focusing the buffer
vim.cmd([[
augroup AUTO_RW
    autocmd!
    autocmd FocusGained,BufEnter * checktime
augroup END
]])

-- treat pull request edit messages as markdown
vim.cmd([[
augroup PRS
    autocmd!
    autocmd BufEnter */PULLREQ_EDITMSG setlocal ft=markdown
augroup END
]])
-- }}}

-- MAPPINGS {{{
u.map("Y", "y$")
u.map("0", "^")

-- scroll by larger increments
u.nnoremap("<C-d>", "3<C-d>")
u.nnoremap("<C-u>", "3<C-u>")

-- navigate by visual lines when lines are wrapped
u.nnoremap("j", "gj")
u.nnoremap("k", "gk")

-- buffer/tab navigation
u.nnoremap("<BS>", "<C-^>")
u.nnoremap_c("<Leader>[", "tabp")
u.nnoremap_c("<Leader>]", "tabn")

-- faster renaming
u.nnoremap("<Leader>r", "*``cgn")

-- load the word under the cursor into the search register
u.nnoremap("<Leader>*", "*``")

-- yank/paste to/from system clipboard
-- (recursive mappings are intentionally used to preserve the benefits of
-- preserving cursor position provided by vim-yoink)
u.nmap("<Leader>d", '"+d')
u.xmap("<Leader>d", '"+d')
u.nmap("<Leader>D", '"+D')
u.xmap("<Leader>D", '"+D')
u.nmap("<Leader>y", '"+y')
u.xmap("<Leader>y", '"+y')
u.nmap("<Leader>Y", '"+Y')
u.xmap("<Leader>Y", '"+Y')
u.nmap("<Leader>p", '"+p')
u.xmap("<Leader>p", '"+p')
u.nmap("<Leader>P", '"+P')
u.xmap("<Leader>P", '"+P')

-- additional emacs mappings that vim-rsi doesn't cover
u.inoremap("<C-k>", "<ESC><Right>C") -- kill the rest of the line
u.cnoremap("<C-p>", "<Up>")
u.cnoremap("<C-n>", "<Down>")

-- edit config files
u.nnoremap_c("<Leader>vev", "edit ~/.config/nvim/init.lua")
u.nnoremap_c("<Leader>vel", "edit ~/.config/nvim/lua/lsp.lua")
u.nnoremap_c("<Leader>vep", "edit ~/.config/nvim/lua/plugins.lua")
u.nnoremap_c("<Leader>ves", "edit ~/.config/nvim/lua/statusline.lua")
u.nnoremap_c("<Leader>veu", "edit ~/.config/nvim/lua/utils.lua")

-- copy the file with another name
u.nnoremap("<Leader>cc", ":saveas %:h<C-z>")

-- create a new file in the same directory
u.nnoremap("<Leader>cn", ":edit %:h<C-z>")

-- toggle qflist
u.nnoremap_c("<Leader>qq", "lua require('utils').toggle_qf()")

-- this is always a typo
u.cnoremap_c("w'", "w")
-- }}}

require("statusline")
require("plugins")
require("lsp")
