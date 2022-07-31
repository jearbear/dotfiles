local u = require("utils")

-- ENV VARIABLES {{{
vim.env.VIM_FILES = vim.fn.expand("~/.config/nvim")
-- }}}

-- LEADER KEYS {{{
vim.g.mapleader = " "
vim.g.maplocalleader = " "
-- }}}

-- PLUGINS {{{
require("packer").startup(function(use)
    use("wbthomason/packer.nvim") -- package manager

    -- themes
    use("EdenEast/nightfox.nvim")
    use({ "catppuccin/nvim", as = "catppuccin" })
    use("folke/tokyonight.nvim")
    use("rose-pine/neovim")
    use("sainnhe/everforest")
    use("savq/melange")

    -- the basics
    use("nvim-lua/plenary.nvim") -- dependency for many lua-based plugins

    -- UI
    use("andymass/vim-matchup") -- more extensive support for matching with `%`
    use("anuvyklack/nvim-keymap-amend") -- required for ^
    use("kevinhwang91/nvim-bqf") -- enhanced qflist (previews FZF integration)
    use("nvim-lualine/lualine.nvim") -- statusline
    use("romainl/vim-cool") -- disable hl on cursor move (neovim is not supported so this may act up)

    -- tree-sitter
    use("RRethy/nvim-treesitter-textsubjects") -- context-aware expansion of selection
    use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })

    -- mappings
    use("AndrewRadev/splitjoin.vim") -- language-aware splits and joins
    use("anuvyklack/hydra.nvim") -- chain mappings together under a common prefix
    use("moll/vim-bbye") -- delete buffers without closing the window
    use("mrjones2014/smart-splits.nvim") -- more sane resizing behavior
    use("numToStr/Comment.nvim") -- key bindings for commenting
    use("tpope/vim-repeat") -- allow `.` to repeate vim-surround actions
    use("tpope/vim-rsi") -- Emacs bindings in command mode

    -- copy pasta
    use("svermeulen/vim-yoink") -- better handling of yanks (yank rings, auto-formatting)
    use("svermeulen/vim-subversive") -- mappings to substitute text

    -- version control
    use("akinsho/git-conflict.nvim") -- better git conflict resolution
    use("lewis6991/gitsigns.nvim") -- VCS change indicators in the gutter
    use("ruifm/gitlinker.nvim") -- create links to Github
    use("sindrets/diffview.nvim") -- git diff across multiple files

    -- completion
    use("windwp/nvim-autopairs") -- automatically complete pairs
    use("tpope/vim-endwise") -- automatically close everything else
    use("RRethy/nvim-treesitter-endwise") -- automatically close everything else (tree-sitter)
    use("dcampos/nvim-snippy") -- snippets
    use("hrsh7th/nvim-cmp") -- auto-completion
    use("hrsh7th/cmp-nvim-lsp") -- auto-completion + LSP integration
    use("dcampos/cmp-snippy") -- auto-completion + snippets integration
    use("hrsh7th/cmp-buffer") -- auto-completion when searching (`/` and `?`)
    use("hrsh7th/cmp-nvim-lsp-signature-help") -- show signature information as you type using the completion window

    -- project navigation + management
    use("elihunter173/dirbuf.nvim") -- minimal file browser
    use("ghillb/cybu.nvim") -- preview when cycling through buffers
    use("mhinz/vim-grepper") -- slicker grep support
    use("mhinz/vim-startify") -- start screen + session management
    use("vim-test/vim-test") -- test execution
    use("wsdjeg/vim-fetch") -- support opening line and column numbers (e.g. foo.bar:13)

    -- LSP stuff
    use("neovim/nvim-lspconfig") -- defines configs for various LSP servers for me
    use("jose-elias-alvarez/null-ls.nvim") -- integrates gofumports, prettier, etc with the LSP support

    -- language support for those not covered by tree-sitter
    use("fladson/vim-kitty")
    use("google/vim-jsonnet")

    -- fzf
    use({ "ibhagwan/fzf-lua", branch = "main" })

    -- trying out
    use("chentoast/marks.nvim")
    use("kylechui/nvim-surround") -- add delete and change enclosing text
    use("jinh0/eyeliner.nvim") -- highlight suggested targets for `f` and `t`
    use("folke/lua-dev.nvim") -- setup the Lua LSP for neovim development
    use("echasnovski/mini.nvim") -- used for mini.ai (enhanced text objects)
end)
-- }}}

-- THEME {{{
vim.opt.termguicolors = true
vim.g.catppuccin_flavour = "mocha"

require("catppuccin").setup({})

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

function _G.custom_fold_text()
    local line = vim.fn.getline(vim.v.foldstart)
    line = string.sub(line, 0, -4) -- remove fold marker
    return line
end

vim.opt.foldenable = false -- default to open folds
vim.opt.foldcolumn = "auto:2" -- show fold indicators in the gutter
vim.opt.foldtext = "v:lua.custom_fold_text()"
vim.opt.fillchars:append({ fold = "-" })

vim.opt.conceallevel = 2 -- hide concealed text

vim.opt.incsearch = true -- jump to search results as you type
vim.opt.hlsearch = true -- highlight search results
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

-- load the word under the cursor into the search register
u.map("n", "<Leader>*", "*``")

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
u.map_c("<Leader>ves", "edit ~/.config/nvim/lua/statusline.lua")
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
-- }}}

require("statusline")
require("plugins")
require("lsp")
