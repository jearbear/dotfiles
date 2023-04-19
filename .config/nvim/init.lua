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
plug("catppuccin/nvim", { as = "catppuccin" })

-- UI
plug("andymass/vim-matchup") -- more extensive support for matching with `%`
plug("anuvyklack/nvim-keymap-amend") -- dependency for vim-matchup
plug("kevinhwang91/nvim-bqf") -- enhanced qflist (previews FZF integration)
plug("nvim-lualine/lualine.nvim") -- statusline

-- tree-sitter
plug("RRethy/nvim-treesitter-endwise") -- automatically close everything else (tree-sitter)
plug("RRethy/nvim-treesitter-textsubjects") -- context-aware expansion of selection
plug("nvim-treesitter/nvim-treesitter", { ["do"] = ":TSUpdate" })
plug("windwp/nvim-ts-autotag") -- automatically close tags

-- mappings
plug("AndrewRadev/splitjoin.vim") -- language-aware splits and joins
plug("anuvyklack/hydra.nvim") -- chain mappings together under a common prefix
plug("mrjones2014/smart-splits.nvim") -- more sane resizing behavior
plug("tpope/vim-rsi") -- Emacs bindings in command mode

-- copy pasta
plug("gbprod/substitute.nvim") -- mappings to substitute text
plug("gbprod/yanky.nvim") -- better handling of yanks (yank rings, auto-formatting)

-- version control
plug("akinsho/git-conflict.nvim", { tag = "*" }) -- better git conflict resolution
plug("lewis6991/gitsigns.nvim") -- VCS change indicators in the gutter
plug("ruifm/gitlinker.nvim") -- create links to Github
plug("nvim-lua/plenary.nvim") -- dependency for gitlinker.nvim

-- completion
plug("windwp/nvim-autopairs") -- automatically complete pairs
plug("tpope/vim-endwise") -- automatically close everything else
plug("dcampos/nvim-snippy") -- snippets
plug("hrsh7th/nvim-cmp") -- auto-completion
plug("hrsh7th/cmp-nvim-lsp") -- auto-completion + LSP integration
plug("dcampos/cmp-snippy") -- auto-completion + snippets integration
plug("hrsh7th/cmp-buffer") -- auto-completion when searching (`/` and `?`)
plug("hrsh7th/cmp-nvim-lsp-signature-help") -- show signature information as you type using the completion window

-- project navigation + management
plug("elihunter173/dirbuf.nvim") -- minimal file browser
plug("vim-test/vim-test") -- test execution
plug("wsdjeg/vim-fetch") -- support opening line and column numbers (e.g. foo.bar:13)

-- LSP stuff
plug("neovim/nvim-lspconfig") -- defines configs for various LSP servers for me
plug("jose-elias-alvarez/null-ls.nvim") -- integrates gofumports, prettier, etc with the LSP support

-- language support for those not covered by tree-sitter
plug("fladson/vim-kitty")

-- fzf
plug("ibhagwan/fzf-lua", { branch = "main" })

-- trying out
plug("chentoast/marks.nvim") -- show marks in the gutter and provide better mappings to manipulate them
plug("jinh0/eyeliner.nvim") -- highlight suggested targets for `f` and `t`
plug("folke/neodev.nvim") -- setup the Lua LSP for neovim development
plug("kylechui/nvim-surround") -- add delete and change enclosing text
plug("echasnovski/mini.nvim") -- used for mini.bufremove, mini.ai (enhanced text objects), mini.align
plug("kristijanhusak/vim-dadbod-ui")
plug("tpope/vim-dadbod") -- dependency for vim-dadbod-ui
plug("kristijanhusak/vim-dadbod-completion")
plug("ThePrimeagen/harpoon")
plug("ghillb/cybu.nvim")
plug("johmsalas/text-case.nvim") -- case-aware substitution
plug("SmiteshP/nvim-navic") -- provide context on where you are
plug("SmiteshP/nvim-navbuddy") -- provide context on where you are
plug("MunifTanjim/nui.nvim")

vim.call("plug#end")
-- }}}

-- THEME {{{
vim.opt.termguicolors = true
vim.g.catppuccin_flavour = "mocha"

require("catppuccin").setup({})

vim.cmd("colorscheme catppuccin")
-- }}}

-- SETTINGS {{{
vim.opt.mouse = "" -- disable mouse

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

function _G.custom_fold_text()
    local line = vim.fn.getline(vim.v.foldstart)
    local marker = string.rep("{", 3)
    if string.sub(line, -#marker) == marker then
        line = string.sub(line, 0, -4) -- remove fold marker
    end
    return line
end

vim.opt.foldenable = false -- default to open folds
vim.wo.foldnestmax = 1
vim.opt.foldtext = "v:lua.custom_fold_text()"
vim.opt.fillchars:append({ fold = " " })

vim.opt.conceallevel = 2 -- hide concealed text

vim.opt.incsearch = true -- jump to search results as you type
vim.opt.hlsearch = false -- highlight search results
vim.opt.ignorecase = true -- perform case-insensitive search and replace
vim.opt.smartcase = true -- override `ignorecase` if capital letters are involved

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

vim.opt.shortmess:append("I") -- don't show vim start screen

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

-- use ripgrep for `grep` command
vim.opt.grepprg = "rg --vimgrep --smart-case --hidden --sort path --glob '!schema.sql' --glob '!pkg/database/models'"
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
    command = "silent! call mkdir(expand('<afile>:p:h'), 'p')",
    group = u.augroup("MKDIR"),
})

-- check if the file has been updated when focusing the buffer
u.autocmd({ "FocusGained", "BufEnter" }, {
    pattern = "*",
    command = "checktime",
    group = u.augroup("AUTO_RW"),
})

-- treat pull request edit messages as markdown
u.autocmd("BufEnter", {
    pattern = "*/PULLREQ_EDITMSG",
    callback = function()
        vim.bo.filetype = "markdown"
    end,
    group = u.augroup("PRS"),
})

-- highlight all results while searching
u.autocmd("CmdlineEnter", {
    pattern = "/,?",
    callback = function()
        vim.opt.hlsearch = true
    end,
    group = u.augroup("SEARCH_START"),
})
u.autocmd("CmdlineLeave", {
    pattern = "/,?",
    callback = function()
        vim.opt.hlsearch = false
    end,
    group = u.augroup("SEARCH_END"),
})
-- }}}

-- MAPPINGS {{{
u.map("", "Y", "y$")
u.map("", "0", "^")

-- scroll by larger increments
u.map("n", "<C-d>", "3<C-d>")
u.map("n", "<C-u>", "3<C-u>")

-- navigate by visual lines when lines are wrapped
u.map("n", "j", "gj")
u.map("n", "k", "gk")

-- move selected lines around
u.map("v", "<C-j>", ":m '>+1<CR>gv=gv")
u.map("v", "<C-k>", ":m '<-2<CR>gv=gv")

-- preserve cursor position when joining
u.map("n", "J", "mzJ`z")

-- insert blank lines
u.map_c("<CR>", "call append(line('.'), '')")
u.map_c("<S-CR>", "call append(line('.') - 1, '')")

-- buffer/tab navigation
u.map("n", "<BS>", "<C-^>")
u.map_c("<Leader>[", "tabp")
u.map_c("<Leader>]", "tabn")

-- navigate quickfix list
u.map("n", "[q", function()
    if not pcall(vim.cmd, "cprevious") then
        vim.cmd("clast")
    end
end)
u.map("n", "]q", function()
    if not pcall(vim.cmd, "cnext") then
        vim.cmd("cfirst")
    end
end)

-- faster renaming
u.map("n", "<Leader>r", "*``cgn")
u.map("n", "g<Leader>r", "g*``cgn")

-- faster substitution
u.map("n", "<Leader>s", ":%s/<C-r><C-w>/")
u.map("v", "<Leader>s", '"ay/<C-R>a<CR>``:%s//')

-- load the word under the cursor into the search register
u.map("n", "<Leader>*", "*``")

-- load the selection into the seach register
u.map("v", "*", '"ay/<C-R>a<CR>``')

-- yank/paste to/from system clipboard
-- (recursive mappings are intentionally used to preserve the benefits of
-- preserving cursor position provided by vim-yoink)
u.map({ "n", "x" }, "<Leader>d", '"+d', { remap = true })
u.map({ "n", "x" }, "<Leader>D", '"+D', { remap = true })
u.map({ "n", "x" }, "<Leader>y", '"+y', { remap = true })
u.map({ "n", "x" }, "<Leader>Y", '"+Y', { remap = true })
u.map({ "n", "x" }, "<Leader>p", '"+p', { remap = true })
u.map({ "n", "x" }, "<Leader>P", '"+P', { remap = true })

-- additional emacs mappings that vim-rsi doesn't cover
u.map("i", "<C-k>", "<ESC><Right>C") -- kill the rest of the line
u.map("c", "<C-p>", "<Up>")
u.map("c", "<C-n>", "<Down>")

-- edit config files
u.map_c("<Leader>vev", "edit ~/.config/nvim/init.lua")
u.map_c("<Leader>vef", "edit ~/.config/nvim/ftplugin")
u.map_c("<Leader>vel", "edit ~/.config/nvim/lua/lsp.lua")
u.map_c("<Leader>vep", "edit ~/.config/nvim/lua/plugins.lua")
u.map_c("<Leader>ves", "edit ~/.config/nvim/snippets")
u.map_c("<Leader>veu", "edit ~/.config/nvim/lua/utils.lua")

-- toggle qflist
u.map("n", "<Leader>qq", function()
    for _, win in pairs(vim.fn.getwininfo()) do
        if win["quickfix"] == 1 then
            vim.cmd("cclose")
            return
        end
    end
    if not vim.tbl_isempty(vim.fn.getqflist()) then
        vim.cmd("copen")
    end
end)

-- this is always a typo
u.map("c", "w'", "w")

-- https://github.com/neovim/neovim/pull/17932#issue-1188088238
u.map("n", "<C-i>", "<C-i>")

-- -- Default to case-insensitive search
-- u.map("n", "/", "/\\c<Left><Left>")
-- u.map("n", "?", "?\\c<Left><Left>")

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

-- center results when jumping to results
u.map("c", "<CR>", function()
    local cmdtype = vim.fn.getcmdtype()
    if cmdtype == "/" then
        return "<CR>zz"
    elseif cmdtype == "?" then
        return "<CR>zz"
    else
        return "<CR>"
    end
end, { expr = true })
-- }}}

require("statusline")
require("plugins")
require("lsp")
