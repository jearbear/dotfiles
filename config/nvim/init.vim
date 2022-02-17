" ENV VARIABLES
let $VIM_FILES=expand('~/.config/nvim')


" LEADER KEYS
let mapleader = ' '
let maplocalleader = ' '

" PLUGINS 
call plug#begin('~/.config/nvim/plugged')

" themes
Plug 'sainnhe/everforest'

" the basics
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} " better syntax highlighting
Plug 'nvim-lua/plenary.nvim'                                " dependency for many lua-based plugins

" statusline
Plug 'rebelot/heirline.nvim'

" mappings
Plug 'AndrewRadev/splitjoin.vim'       " language-aware splits and joins
" Plug 'junegunn/vim-easy-align'         " easily vertically align text (like these comments!)
Plug 'numToStr/Comment.nvim'           " key bindings for commenting
Plug 'tpope/vim-rsi'                   " Emacs bindings in command mode
Plug 'tpope/vim-surround'              " additional mappings to manipulate brackets
Plug 'tpope/vim-unimpaired'            " mostly use for [<Space> and ]<Space>
Plug 'wellle/targets.vim'              " additional text objects
Plug 'moll/vim-bbye'                   " delete buffers without closing the window

" copy pasta
Plug 'svermeulen/vim-yoink'            " better handling of yanks (yank rings, auto-formatting)
Plug 'svermeulen/vim-subversive'       " mappings to substitute text

" version control
Plug 'ruifm/gitlinker.nvim'
Plug 'f-person/git-blame.nvim'
Plug 'lewis6991/gitsigns.nvim'         " VCS change indicators in the gutter
Plug 'sindrets/diffview.nvim'

" project management
Plug 'romainl/vim-qf'                  " slicker qf and loclist handling
Plug 'tpope/vim-eunuch'                " unix shell commands in command mode

" completion
Plug 'ZhiyuanLck/smart-pairs'
Plug 'RRethy/nvim-treesitter-endwise' " automatically close everything else
Plug 'dcampos/cmp-snippy'
Plug 'dcampos/nvim-snippy'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/nvim-cmp'

" project navigation
Plug 'justinmk/vim-dirvish'            " minimal file browser
Plug 'mhinz/vim-grepper'               " slicker grep support
Plug 'wsdjeg/vim-fetch'                " support opening line and column numbers (e.g. foo.bar:13)

" LSP stuff
Plug 'neovim/nvim-lspconfig'           " defines configs for various LSP servers for me
Plug 'jose-elias-alvarez/null-ls.nvim' " integrates gofumports, prettier, etc with the LSP support
Plug 'ojroques/nvim-lspfuzzy'          " use FZF for LSP results

" language support for those not covered by tree-sitter
Plug 'fladson/vim-kitty'
Plug 'google/vim-jsonnet'

" fzf
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

" trying out
Plug 'mhinz/vim-startify'
Plug 'anuvyklack/pretty-fold.nvim' " prettier fold markers and previews
Plug 'folke/which-key.nvim' 
Plug 'andymass/vim-matchup'

Plug 'catppuccin/nvim', {'as': 'catppuccin'}


call plug#end()

" COLOR SCHEME 
set termguicolors
lua require('theme')
" source $VIM_FILES/theme.vim              " this file is created by running `set-theme`
colorscheme catppuccin

let g:everforest_background = 'soft'

" VIM SETTINGS 
set hidden                               " allow switching buffers without saving

set noruler                              " disable the default buffer ruler

set expandtab shiftwidth=4 softtabstop=4 " use 4 spaces for indentation

set cursorline                           " highlight the line the cursor is on
set scrolloff=5                          " ensure 5 lines of padding between the cursor and the edges of the window

set nojoinspaces                         " only insert one space when joining lines
set wrap linebreak                       " wrap lines and do so on word boundaries only
set breakindent showbreak=..             " indent wrapped lines with `..`

set fillchars+=diff:╱

set lazyredraw                           " don't redraw the screen while executing macros and registers

set nofoldenable                         " default to open folds
set conceallevel=2                       " hide concealed text

set inccommand=nosplit                   " display incremental results of substitution commands in the buffer
set incsearch nohlsearch                 " incrementally search and don't highlight when done
set ignorecase smartcase                 " only care about case when searching if it includes capital letters

set gdefault                             " default to global (within the line) substitution

set splitbelow splitright                " default to opening splits below and to the right

set virtualedit=block                    " allow the cursor to move off the end of the line in visual block mode

set suffixes+=,,                         " during completion, if prefixes are the same, prefer files with suffixes

set wildignore+=*.pyc,*.swp,*.lock,*.min.js,*.min.css,tags
set wildignore+=*/tmp/*,*/target/*,*/venv/*,*/vendor/*,*/elm-stuff/*,*/bazel*/*,*/build/*
set wildmenu wildignorecase
set wildmode=full,full

set wildcharm=<C-z>                   " allows invoking completion menu with <C-z>

set shortmess+=c                      " don't show messages when performing completion
set completeopt=menu,menuone,noselect " when completing, show a menu even if there is only one result

" nicer tabline {{{
function! Tabline()
    let s = ''
    for i in range(tabpagenr('$'))
        let tab = i + 1
        let winnr = tabpagewinnr(tab)
        let buflist = tabpagebuflist(tab)
        let bufnr = buflist[winnr - 1]
        let bufname = bufname(bufnr)
        let bufmodified = getbufvar(bufnr, '&mod')

        let s .= '%' . tab . 'T'
        let s .= (tab == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#')
        let s .= ' ' . len(buflist) .' - '
        let s .= (bufname !=# '' ? fnamemodify(bufname, ':t') . ' ' : '[No Name] ')

        if bufmodified
            let s .= '[+] '
        endif
    endfor

    let s .= '%#TabLineFill#'

    return s
endfunction
" }}}
set tabline=%!Tabline()

" turn search highlighting on while searching
augroup HL_SEARCH
    autocmd!
    autocmd CmdlineEnter /,\? :setlocal hlsearch
    autocmd CmdlineLeave /,\? :setlocal nohlsearch
augroup END

set spelllang=en
set dictionary+=/usr/share/dict/words

" ensure that these directories exist if they don't already
silent !mkdir $VIM_FILES/backup// > /dev/null 2>&1
silent !mkdir $VIM_FILES/swp// > /dev/null 2>&1
silent !mkdir $VIM_FILES/undo// > /dev/null 2>&1

" relegate backup, swp, and undo files to their own directory
set backupdir=$VIM_FILES/backup//
set directory=$VIM_FILES/swp//
set undofile undodir=$VIM_FILES/undo//

" allow jumping to filename:linenum
set isfname-=:

" auto read/write file on enter/jump
set noswapfile autoread autowrite
augroup AUTO_RW
    autocmd!
    autocmd FocusGained,BufEnter * checktime
augroup END

" default to bash filetype for ft=sh
let g:is_bash = 1

" automatically create parent directories as needed when saving files
augroup MKDIR
    autocmd!
    autocmd BufWritePre,FileWritePre * silent! call mkdir(expand('<afile>:p:h'), 'p')
augroup END


" FUNCTIONS
function! PushMark(is_global) " {{{
    if a:is_global
        let l:curr = char2nr('Z')
    else
        let l:curr = char2nr('z')
    endif
    let l:until = l:curr - 25
    while l:curr > l:until
        call setpos("'" . nr2char(l:curr), getpos("'" . nr2char(l:curr - 1)))
        let l:curr -= 1
    endwhile
    call setpos("'" . nr2char(l:curr), getpos("."))
endfunction
" }}}


" MAPPINGS 
map Y y$
map 0 ^

nnoremap <C-d> 3<C-d> " `:set scroll...` doesn't seem to persist so we rebind the defaults instead
nnoremap <C-u> 3<C-u>

" navigate by visual lines when wrapped
nnoremap j gj
nnoremap k gk

" buffer navigation
nnoremap <BS> <C-^>
nnoremap <silent> <Leader>[ :bprevious<CR>
nnoremap <silent> <Leader>] :bnext<CR>

" tab navigation
nnoremap <silent> <Leader>{ :tabp<CR>
nnoremap <silent> <Leader>} :tabn<CR>

" faster renaming
nnoremap <Leader>r *``cgn

" load the word under the cursor into the search register
nnoremap <Leader>* *``

" yank/paste to/from system clipboard
" (recursive mappings are intentionally used to preserve the benefits of
" preserving cursor position provided by vim-yoink)
nmap <Leader>d "+d
xmap <Leader>d "+d
nmap <Leader>D "+D
xmap <Leader>D "+D
nmap <Leader>y "+y
xmap <Leader>y "+y
nmap <Leader>Y "+Y
xmap <Leader>Y "+Y
nmap <Leader>p "+p
xmap <Leader>p "+p
nmap <Leader>P "+P
xmap <Leader>P "+P

" repeat macro on selection
xnoremap <silent> . :norm.<CR>

" additional readline (emacs) mappings that vim-rsi doesn't cover
inoremap <C-k> <ESC><Right>C
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

" edit/save vimrc
nnoremap <silent> <Leader>vev :e ~/.config/nvim/init.vim<CR>
nnoremap <silent> <Leader>vel :e ~/.config/nvim/lua/lsp.lua<CR>
nnoremap <silent> <Leader>vep :e ~/.config/nvim/lua/plugins.lua<CR>
nnoremap <silent> <Leader>ves :e ~/.config/nvim/lua/statusline.lua<CR>
nnoremap <silent> <Leader>vr :source ~/.config/nvim/init.vim<CR>:lua require'heirline'.reset_highlights()<CR>

" maximize the pane
nnoremap <C-w>m <C-w><bar><C-w>_

" copy the file with another name
nnoremap <Leader>cc :saveas %:h<C-z>

" create a new file in the same directory
nnoremap <Leader>cn :e %:h<C-z>

" Push to marks A-Z
nnoremap <silent> mm :call PushMark(1)<CR>


" STATUSLINE
lua require('statusline')


" PLUGIN SETTINGS 
lua require('plugins')

" vim-dirvish {{{
augroup DIRVISH
    autocmd FileType dirvish nmap <buffer> q <Plug>(dirvish_quit)
augroup END
" }}}

" vim-mucomplete {{{
let g:mucomplete#can_complete = {}
let g:mucomplete#can_complete.default = {
            \    'omni': { t -> strlen(&l:omnifunc) > 0 }
            \    }
let g:mucomplete#chains = {}
let g:mucomplete#chains.default = ['omni']
" }}}

" vim-qf {{{
let g:qf_mapping_ack_style = 1

nmap <Leader>qq <Plug>(qf_qf_toggle)
nmap <Leader>ql <Plug>(qf_loc_toggle)
nmap [q <Plug>(qf_qf_previous)
nmap ]q <Plug>(qf_qf_next)
nmap [l <Plug>(qf_loc_previous)
nmap ]l <Plug>(qf_loc_next)

augroup QF
    autocmd FileType qf nnoremap <silent> <buffer> dd 0:Reject<CR>
    autocmd FileType qf xnoremap <silent> <buffer> d :Reject<CR>
    autocmd FileType qf nnoremap <silent> <buffer> <BS> <Nop>
    autocmd Filetype qf nnoremap <buffer> q :q<CR>
    autocmd Filetype qf nnoremap <buffer> Q :q<CR>
augroup END
" }}}

" vim-fugitive {{{
" nnoremap <silent> <Leader>gs :Git<CR>
" nnoremap <silent> <Leader>gb :GBrowse<CR>
" xnoremap <silent> <Leader>gb :GBrowse<CR>
" nnoremap <silent> <Leader>gl :GBrowse!<CR>
" xnoremap <silent> <Leader>gl :GBrowse!<CR>
" }}}

" vim-easy-align {{{
" nmap ga <Plug>(EasyAlign)
" xmap ga <Plug>(EasyAlign)
" }}}

" vim-grepper {{{
runtime plugin/grepper.vim

let g:grepper.prompt_text = '$t> '
let g:grepper.switch = 1
let g:grepper.tools = ['rg']
let g:grepper.stop = 500
let g:grepper.prompt_quote = 2

nnoremap <silent> \ :Grepper<CR>
nnoremap <silent> <Leader>\ :Grepper -buffer<CR>
nmap gs <Plug>(GrepperOperator)
xmap gs <Plug>(GrepperOperator)
" }}}

" targets.vim {{{
let g:targets_seekRanges = 'cc cr cb cB lc ac Ac'      " ranges on the cursor
let g:targets_seekRanges .= ' lr'                      " range around the cursor, fully contained on the same line
let g:targets_seekRanges .= ' rr'                      " range ahead of the cursor, fully contained on the same line
let g:targets_seekRanges .= ' lb ar ab lB Ar aB Ab AB' " ranges around the cursor, multiline
let g:targets_seekRanges .= ' ll'                      " ranges behind the cursor, fully contained on the same line
" }}}

" vim-rsi {{{
let g:rsi_no_meta = 1
" }}}

" fzf.vim {{{
function! DeleteBuffers() " {{{
    function! s:delete_buffers(lines)
        execute 'bwipeout' join(map(a:lines, {_, line -> matchstr(line, '\[\zs[0-9]*\ze\]')}))
    endfunction

    let sorted = fzf#vim#_buflisted_sorted()
    let header_lines = '--header-lines=' . (bufnr('') == get(sorted, 0, 0) ? 1 : 0)
    let tabstop = len(max(sorted)) >= 4 ? 9 : 8
    return fzf#run(fzf#wrap(fzf#vim#with_preview({
                \ 'source':  map(sorted, 'fzf#vim#_format_buffer(v:val)'),
                \ 'sink*':   { lines -> s:delete_buffers(lines) },
                \ 'options': ['+m', '-x', '--tiebreak=index', header_lines, '--ansi', '-d', '\t', '--with-nth', '3..', '-n', '2,1..2', '--prompt', 'BufDel> ', '--preview-window', '+{2}-/2', '--tabstop', tabstop, '--multi']
                \})))
endfunction " }}}

let g:fzf_layout = { 'window': { 'width': 0.95, 'height': 0.95, 'border': 'sharp' } }
let g:fzf_history_dir = '~/.fzf-history'
let g:fzf_action = {
            \ 'ctrl-t': 'tab split',
            \ 'ctrl-s': 'split',
            \ 'ctrl-v': 'vsplit',
            \ }
let g:fzf_preview_window = ['up:80%,border-sharp', 'ctrl-/']

nnoremap <silent> <Leader>f :Files<CR>
nnoremap <silent> <Leader>F :GFiles?<CR>
nnoremap <silent> <Leader>l :Buffers<CR>
nnoremap <silent> <Leader>L :call DeleteBuffers()<CR>
nnoremap <silent> <Leader>; :BLines<CR>
nnoremap <silent> <Leader>: :History:<CR>
nnoremap <silent> <Leader>k :BTags<CR>
nnoremap <silent> <Leader>h :Help<CR>
nnoremap <silent> <Leader>m :Marks<CR>
nnoremap <silent> <bar> :Rg<CR>
" }}}

" vim-yoink {{{
let g:yoinkAutoFormatPaste = 1
let g:yoinkIncludeDeleteOperations = 1

nmap <C-n> <plug>(YoinkPostPasteSwapForward)
nmap <C-p> <plug>(YoinkPostPasteSwapBack)

nmap P <plug>(YoinkPaste_P)
nmap p <plug>(YoinkPaste_p)

nmap [y <plug>(YoinkRotateBack)
nmap ]y <plug>(YoinkRotateForward)

nmap y <plug>(YoinkYankPreserveCursorPosition)
xmap y <plug>(YoinkYankPreserveCursorPosition)

nmap <C-[> <plug>(YoinkPostPasteToggleFormat)
" }}}

" vim-subversive {{{
nmap S <plug>(SubversiveSubstituteToEndOfLine)
nmap s <plug>(SubversiveSubstitute)
nmap ss <plug>(SubversiveSubstituteLine)
xmap P <plug>(SubversiveSubstitute)
xmap p <plug>(SubversiveSubstitute)
xmap s <plug>(SubversiveSubstitute)
" }}}

" Comment.nvim {{{
nmap <Leader>/ gcc
vmap <Leader>/ gc
" }}}

" vim-slash {{{
noremap <plug>(slash-after) zz
" }}}

" vim-bbye {{{
nnoremap <silent> Q :Bwipeout<CR>
" }}}

" vim-startify {{{
let g:startify_session_persistence = 1
let g:startify_session_delete_buffers = 1
let g:startify_change_to_dir = 0
let g:startify_relative_path = 1
let g:startify_commands = [ ]
let g:startify_bookmarks = [
            \ { 'vv': '~/.config/nvim/init.vim' },
            \ { 'vl': '~/.config/nvim/lua/lsp.lua' },
            \ { 'vp': '~/.config/nvim/lua/plugins.lua' },
            \ { 'vs': '~/.config/nvim/lua/statusline.lua' },
            \ ]
let g:startify_fortune_use_unicode = 1
let g:startify_lists = [
            \ { 'type': 'dir',       'header': ['   Latest Edits'] },
            \ { 'type': 'bookmarks', 'header': ['   Bookmarks'] },
            \ { 'type': 'sessions',  'header': ['   Sessions'] },
            \ { 'type': 'commands',  'header': ['   Commands'] },
            \ ]

nnoremap <silent> <Leader>S :Startify<CR>
nnoremap <Leader>ss :SSave!<Space>
nnoremap <Leader>sl :SLoad!<Space>
nnoremap <Leader>sd :SDelete!<Space>
nnoremap <silent> <Leader>sc :SClose<CR>
" }}}

" vim-matchup {{{
let g:matchup_matchparen_offscreen = {'method': 'popup'}
" }}}

" git-blame.nvim {{{
let g:gitblame_enabled = 0

nnoremap <silent> <Leader>gb :GitBlameToggle<CR>
" }}}

" diffview.nvim {{{
nnoremap <silent> <leader>gd :DiffviewFileHistory<CR>
" }}}


" LSP
lua require('lsp')


" LANGUAGE AUTO GROUPS 
augroup SH
    autocmd!
    autocmd FileType sh setlocal iskeyword+=-
augroup END

augroup GO
    autocmd!

    " let g:go_fold_enable = ['import']

    " autocmd FileType go setlocal foldenable foldmethod=expr foldexpr=v:lnum==1?'>1':getline(v:lnum)=~'import'?1:nvim_treesitter#foldexpr()
    autocmd FileType go setlocal noexpandtab shiftwidth=8
    autocmd FileType go setlocal textwidth=100
augroup END

augroup HASKELL
    autocmd!
    autocmd FileType haskell setlocal shiftwidth=2 softtabstop=2
augroup END

augroup PYTHON
    autocmd!

    " Drop a breakpoint and set a mark for it
    autocmd Filetype python nnoremap <silent> <buffer> <Leader>pr Oimport bpdb; bpdb.set_trace()<ESC>mp
augroup END

augroup RUST
    autocmd!
    autocmd FileType rust nmap <buffer> <C-]> <Plug>(rust-def)
    autocmd FileType rust nmap <buffer> K <Plug>(rust-doc)
augroup END

augroup VIM
    autocmd!
    autocmd FileType vim setlocal foldenable foldmethod=marker
augroup END

augroup JAVASCRIPT
    autocmd!

    autocmd Filetype javascript,javascriptreact,typescript,typescriptreact setlocal shiftwidth=2 softtabstop=2
augroup END

augroup PRS
    autocmd!
    autocmd BufEnter */PULLREQ_EDITMSG setlocal ft=markdown
augroup END

augroup YAML
    autocmd!
    autocmd Filetype yaml setlocal shiftwidth=2 softtabstop=2
augroup END

augroup LUA
    autocmd!
    autocmd FileType lua setlocal foldenable foldmethod=marker
augroup END


runtime local.vim
