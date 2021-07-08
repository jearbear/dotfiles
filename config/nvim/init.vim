" ENV VARIABLES {{{
let $VIMFILES=expand('~/.config/nvim')
" }}}

" LEADER KEYS {{{
let mapleader = ' '
let maplocalleader = ' '
" }}}

" PLUGINS {{{
call plug#begin('~/.config/nvim/plugged')

" themes
Plug 'chriskempson/base16-vim'

" mappings
Plug 'AndrewRadev/splitjoin.vim'
Plug 'junegunn/vim-easy-align'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'wellle/targets.vim'

" copy pasta
Plug 'svermeulen/vim-yoink'
Plug 'svermeulen/vim-subversive'

" version control
Plug 'lambdalisue/gina.vim'
Plug 'mhinz/vim-signify'

" project management
Plug 'dense-analysis/ale'
Plug 'jpalardy/vim-slime'
Plug 'romainl/vim-qf'
Plug 'tpope/vim-eunuch'

" completion
Plug 'lifepillar/vim-mucomplete'
Plug 'rstacruz/vim-closer'
Plug 'tpope/vim-endwise'

" project navigation
Plug 'justinmk/vim-dirvish'
Plug 'mhinz/vim-grepper'
Plug 'wsdjeg/vim-fetch'

" language support
Plug 'ElmCast/elm-vim', { 'for': 'elm' }
Plug 'MaxMEllon/vim-jsx-pretty', { 'for': 'javascript' }
Plug 'cespare/vim-toml', { 'for': 'toml' }
Plug 'elixir-editors/vim-elixir'
Plug 'fatih/vim-go', { 'for': 'go', 'do': ':GoInstallBinaries' }
Plug 'godlygeek/tabular', { 'for': 'markdown' }
Plug 'lervag/vimtex', { 'for': 'latex' }
Plug 'neovimhaskell/haskell-vim', { 'for': 'haskell' }
Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
Plug 'rodjek/vim-puppet', { 'for': 'puppet' }
Plug 'rust-lang/rust.vim', { 'for': 'rust' }
Plug 'tpope/vim-ragtag', { 'for': 'html' }
Plug 'vim-ruby/vim-ruby', { 'for': 'ruby' }

" fzf
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

" trying out
Plug 'Asheq/close-buffers.vim'
" Plug 'lukas-reineke/indent-blankline.nvim', {'branch': 'lua'}
Plug 'mbbill/undotree'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'preservim/tagbar'
Plug 'tpope/vim-obsession'

call plug#end()
" }}}

" COLOR SCHEME {{{
if filereadable(expand('~/.vimrc_background'))
    set termguicolors
    source ~/.vimrc_background
endif
" }}}

" VIM SETTINGS {{{
set hidden                               " allow switching buffers without saving

set noruler                              " disable the default buffer ruler

set expandtab shiftwidth=4 softtabstop=4 " use 4 spaces for indentation

set cursorline                           " highlight the line the cursor is on
set scrolloff=5                          " ensure 5 lines of padding between the cursor and the edges of the window

set nojoinspaces                         " only insert one space when joining lines
set wrap linebreak                       " wrap lines and do so on word boundaries only
set breakindent showbreak=..             " indent wrapped lines with `..`

set lazyredraw                           " don't redraw the screen while executing macros and registers

set nofoldenable                         " default to open folds
set conceallevel=2                       " hide concealed text

set inccommand=nosplit                   " display incremental results of substitution commands in the buffer
set incsearch nohlsearch                 " incrementally search and don't highlight when done
set ignorecase smartcase                 " only care about case when searching if it includes capital letters
set nowrapscan                           " don't wrap around when searching

set gdefault                             " default to global substitution

set splitbelow splitright                " default to opening splits below and to the right

set virtualedit=block                    " allow the cursor to move off the end of the line in visual block mode

set suffixes+=,,                         " during completion, if prefixes are the same, prefer files with suffixes

set wildignore+=*.pyc,*.swp,*.lock,*.min.js,*.min.css,tags
set wildignore+=*/tmp/*,*/target/*,*/venv/*,*/vendor/*,*/elm-stuff/*,*/bazel*/*,*/build/*
set wildmenu wildignorecase
set wildmode=full,full

set wildcharm=<C-z>          " allows invoking completion menu with <C-z>

set shortmess+=c             " don't show messages when performing completion
set completeopt=menu,menuone " when completing, show a menu even if there is only one result

hi StatusLine cterm=bold   gui=bold
hi Comment    cterm=italic gui=italic

set statusline=\ \                              " padding
set statusline+=%f                              " filename
set statusline+=\ %m%*                          " modified flag
set statusline+=%=                              " center divide
set statusline+=%{gina#component#repo#branch()} " vcs info
set statusline+=\ \                             " padding
set statusline+=\ \                             " padding
set statusline+=\ \                             " padding
set statusline+=%l/%L                           " line number / number of lines
set statusline+=\ \                             " padding

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
set tabline=%!Tabline()
" }}}

set spelllang=en
set dictionary+=/usr/share/dict/words

" ensure that these directories exist if they don't already
silent !mkdir $VIMFILES/backup// > /dev/null 2>&1
silent !mkdir $VIMFILES/swp// > /dev/null 2>&1
silent !mkdir $VIMFILES/undo// > /dev/null 2>&1

" relegate backup, swp, and undo files to their own directory
set backupdir=$VIMFILES/backup//
set directory=$VIMFILES/swp//
set undofile undodir=$VIMFILES/undo//

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

" turn search highlighting on while searching
augroup HL_SEARCH
    autocmd!
    autocmd CmdlineEnter /,\? :setlocal hlsearch
    autocmd CmdlineLeave /,\? :setlocal nohlsearch
augroup END
" }}}

" MAPPINGS {{{
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
nnoremap <silent> Q :bprevious <Bar> bdelete #<CR>

" tab navigation
nnoremap <silent> <Leader>{ :tabp<CR>
nnoremap <silent> <Leader>} :tabn<CR>

" faster renaming
nnoremap <Leader>r *``cgn
nnoremap <Leader>gr g*``cgn

" load the word under the cursor into the search register
nnoremap <Leader>* *``

" more convenient substitution
nnoremap <Leader>s :s/<C-r><C-w>/
xnoremap <Leader>s :s/
nnoremap <Leader>S :%s/<C-r><C-w>/

" search for whatever is in the " register
nnoremap <Leader>n /<C-r>"<CR>
nnoremap <Leader>N ?<C-r>"<CR>

" delete text without yanking
nnoremap <Leader>d "_d
xnoremap <Leader>d "_d

" yank text to the system clipboard
" (recursive mappings are intentionally used to preserve the benefits of
" preserving cursor position provided by vim-yoink)
nmap <Leader>y "+y
xmap <Leader>y "+y

" repeat macro on selection
xnoremap <silent> . :norm.<CR>

" additional readline (emacs) mappings that vim-rsi doesn't cover
inoremap <C-k> <ESC><Right>C
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

" this is never intentional
cnoremap w' w

" edit/save vimrc
nnoremap <silent> <Leader>ve :e ~/.config/nvim/init.vim<CR>
nnoremap <silent> <Leader>vr :source ~/.config/nvim/init.vim<CR>

" maximize the window
nnoremap <C-w>m <C-w><bar><C-w>_

" copy the file with another name
nnoremap <Leader>cc :saveas %:h<C-z>
" }}}

" FUNCTIONS {{{
function MakeScratch(ft)
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal noswapfile
    execute 'setlocal filetype=' . a:ft
endfunction

command! MD call MakeScratch('markdown')
command! JSON call MakeScratch('json')
" }}}

" PLUGIN SETTINGS {{{
" vim-qf {{{
let g:qf_mapping_ack_style = 1

nmap <Leader>qq <Plug>(qf_qf_toggle)
nmap <silent> [q :cprev<CR>
nmap <silent> ]q :cnext<CR>

augroup QF
    autocmd FileType qf nnoremap <silent> <buffer> dd 0:Reject<CR>
    autocmd FileType qf nnoremap <buffer> <BS> <Nop>
augroup END
" }}}

" gina.vim {{{
nnoremap <silent> <Leader>gs :Gina status<CR>
nnoremap <silent> <Leader>gb :.Gina browse : --exact --scheme=blame<CR>
nnoremap <silent> <Leader>gh :Gina browse : --exact<CR>
xnoremap <silent> <Leader>gh :Gina browse : --exact<CR>
nnoremap <silent> <Leader>gl "+:Gina browse : --yank --exact<CR>
xnoremap <silent> <Leader>gl "+:Gina browse : --yank --exact<CR>
" }}}

" vim-easy-align {{{
nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)
" }}}

" vim-grepper {{{
runtime plugin/grepper.vim

let g:grepper.prompt_text = '$t> '
let g:grepper.switch = 1
let g:grepper.tools = ['rg']
let g:grepper.stop = 500

nnoremap <silent> \ :Grepper<CR>
nnoremap <silent> <Leader>\ :Grepper -buffer<CR>
nnoremap <silent> <bar> :Grepper -buffers<CR>
nmap gs <Plug>(GrepperOperator)
xmap gs <Plug>(GrepperOperator)
" }}}

" ale {{{
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_text_changed = 'never'
let g:ale_set_highlights = 0
let g:ale_sign_error = '!!'
let g:ale_sign_warning = '!!'

let g:ale_linters = {
            \ 'haskell': ['stack-build', 'hlint'],
            \ 'javascript': ['eslint'],
            \ }
let g:ale_fixers = {
            \ '*': ['remove_trailing_lines', 'trim_whitespace'],
            \ 'elixir': ['mix_format'],
            \ 'haskell': [{_ -> { 'command': 'ormolu --mode inplace %t', 'read_temporary_file': 1 }}],
            \ 'python': ['black'],
            \ 'rust': 'rustfmt',
            \ 'javascript': 'eslint',
            \ }
let g:ale_fix_on_save = 1

let g:ale_python_auto_pipenv = 1

let g:ale_rust_cargo_use_clippy = 1

nmap <C-k> <Plug>(ale_previous)
nmap <C-j> <Plug>(ale_next)

augroup ALE
    autocmd!
    autocmd FileType rust nmap <buffer> <Leader>d <Plug>(ale_go_to_definition)
    autocmd FileType rust nmap <buffer> <Leader>h <Plug>(ale_hover)
    autocmd FileType rust setlocal omnifunc=ale#completion#OmniFunc
augroup END
" }}}

" targets.vim {{{
let g:targets_seekRanges = 'cc cr cb cB lc ac Ac'      " ranges on the cursor
let g:targets_seekRanges .= ' lr'                      " range around the cursor, fully contained on the same line
let g:targets_seekRanges .= ' rr'                      " range ahead of the cursor, fully contained on the same line
let g:targets_seekRanges .= ' lb ar ab lB Ar aB Ab AB' " ranges around the cursor, multiline
let g:targets_seekRanges .= ' ll'                      " ranges behind the cursor, fully contained on the same line
" }}}

" vim-slime {{{
let g:slime_target = 'tmux'
let g:slime_paste_file = tempname()
" }}}

" vim-go {{{
let g:go_fmt_command = 'goimports'
let g:go_list_type = 'quickfix'
let g:go_fold_enable = ['import']
" }}}

" vim-rsi {{{
let g:rsi_no_meta = 1
" }}}

" fzf.vim {{{
let g:fzf_layout = { 'down': 10 }
let g:fzf_history_dir = '~/.fzf-history'
let g:fzf_action = {
            \ 'ctrl-t': 'tab split',
            \ 'ctrl-s': 'split',
            \ 'ctrl-v': 'vsplit',
            \ }
let g:fzf_preview_window = []

command! SmartFiles execute (len(system('git rev-parse')) ? ':Files' : ':GFiles')
command! Dotfiles call fzf#vim#files('~/.dotfiles')

nnoremap <silent> <Leader>f :SmartFiles<CR>
nnoremap <silent> <Leader>l :Buffers<CR>
nnoremap <silent> <Leader>; :BLines<CR>
nnoremap <silent> <Leader>: :Lines<CR>
nnoremap <silent> <Leader>k :BTags<CR>
nnoremap <silent> <Leader>m :Marks<CR>

augroup FZF
    autocmd!
    autocmd User FzfStatusLine setlocal statusline=%#StatusLine#\ »\ fzf
augroup END
" }}}

" elm-vim {{{
let g:elm_setup_keybindings = 0
" }}}

" vim-ruby {{{
let ruby_foldable_groups = 'def class module do case'
" }}}

" vim-signify {{{
let g:signify_vcs_list = ['git']
" }}}

" vim-yoink {{{
let g:yoinkAutoFormatPaste = 1
let g:yoinkIncludeDeleteOperations = 1

nmap <C-=> <plug>(YoinkPostPasteToggleFormat)
nmap <C-n> <plug>(YoinkPostPasteSwapForward)
nmap <C-p> <plug>(YoinkPostPasteSwapBack)
nmap P <plug>(YoinkPaste_P)
nmap [y <plug>(YoinkRotateBack)
nmap ]y <plug>(YoinkRotateForward)
nmap p <plug>(YoinkPaste_p)
nmap y <plug>(YoinkYankPreserveCursorPosition)
xmap y <plug>(YoinkYankPreserveCursorPosition)
" }}}

" vim-subversive {{{
nmap S <plug>(SubversiveSubstituteToEndOfLine)
nmap s <plug>(SubversiveSubstitute)
nmap ss <plug>(SubversiveSubstituteLine)
xmap P <plug>(SubversiveSubstitute)
xmap p <plug>(SubversiveSubstitute)
xmap s <plug>(SubversiveSubstitute)
" }}}

" {{{ vim-tagbar
let g:tagbar_zoomwidth = 0
let g:tagbar_autoclose = 1
let g:tagbar_autofocus = 1
let g:tagbar_show_data_type = 1

let g:tagbar_type_elixir = {
    \ 'ctagstype' : 'elixir',
    \ 'kinds' : [
        \ 'p:protocols',
        \ 'm:modules',
        \ 'e:exceptions',
        \ 'y:types',
        \ 'd:delegates',
        \ 'f:functions',
        \ 'c:callbacks',
        \ 'a:macros',
        \ 't:tests',
        \ 'i:implementations',
        \ 'o:operators',
        \ 'r:records'
    \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
        \ 'p' : 'protocol',
        \ 'm' : 'module'
    \ },
    \ 'scope2kind' : {
        \ 'protocol' : 'p',
        \ 'module' : 'm'
    \ },
    \ 'sort' : 0
\ }

let g:tagbar_type_ruby = {
    \ 'kinds' : [
        \ 'm:modules',
        \ 'c:classes',
        \ 'd:describes',
        \ 'C:contexts',
        \ 'f:methods',
        \ 'F:singleton methods'
    \ ]
\ }

nnoremap <silent> <Leader>K :TagbarToggle<CR>
" }}}

" {{{ undotree
let g:undotree_SetFocusWhenToggle = 1
let g:undotree_WindowLayout = 3
let g:undotree_SplitWidth = 50

nnoremap <silent> <Leader>u :UndotreeToggle<CR>
" }}}

" {{{ vim-obsession
" save a session under the current git branch name
function! s:SaveSession() abort
    if getcwd() =~ '/' . gina#component#repo#name() . '$'
        let branch = gina#component#repo#branch()
        if branch ==# ''
            Obsession
        else
            let _ = system('mkdir -p .git/sessions')
            execute 'Obsession .git/sessions/' . branch . '.vim'
        endif
    else
        echo 'SaveSession only works in the root .git directory'
    endif
endfunction

command! SaveSession call s:SaveSession()

nnoremap <silent> <Leader>vs :SaveSession<CR>
" }}}

" {{{ vim-commentary
nmap <Leader>/ gcc
vmap <Leader>/ gc
" }}}

" {{{ close-buffers.vim
nnoremap <silent> <Leader>Q :Bdelete menu<CR>
" }}}

" {{{ nvim-treesitter
lua <<EOF
require'nvim-treesitter.configs'.setup {
    highlight = {
        enable = true,
    },
    indent = {
        enable = true,
    },
}
EOF
" }}}
" }}}

" LANGUAGE AUTO GROUPS {{{
augroup SH
    autocmd!
    autocmd FileType sh setlocal iskeyword+=-
augroup END

augroup GO
    autocmd!
    autocmd FileType go setlocal foldenable foldmethod=syntax
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

augroup JSON
    autocmd!
    autocmd FileType json nmap <silent> <buffer> <Leader>fp :%!jq<CR>
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
" }}}

runtime local.vim
