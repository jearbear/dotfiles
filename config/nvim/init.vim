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
Plug 'svermeulen/vim-cutlass'
Plug 'svermeulen/vim-yoink'
Plug 'svermeulen/vim-subversive'

" version control
Plug 'lambdalisue/gina.vim'
Plug 'mhinz/vim-signify'

" project management
Plug 'alok/notational-fzf-vim'
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

" language support
Plug 'ElmCast/elm-vim', { 'for': 'elm' }
Plug 'MaxMEllon/vim-jsx-pretty', { 'for': 'javascript' }
Plug 'cespare/vim-toml', { 'for': 'toml' }
Plug 'elixir-editors/vim-elixir'
Plug 'fatih/vim-go', { 'for': 'go', 'do': ':GoInstallBinaries' }
Plug 'godlygeek/tabular', { 'for': 'markdown' }
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

" writing
Plug 'junegunn/goyo.vim'

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
set scrolloff=999                        " ensure 5 lines of padding between the cursor and the edges of the window

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
set statusline+=%l/%L
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
augroup AUTORW
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
" }}}

" MAPPINGS {{{
map <silent> Y y$
map <silent> 0 ^

nnoremap <C-d> 3<C-d> " `:set scroll...` doesn't seem to persist so we rebind the defaults instead
nnoremap <C-u> 3<C-u>

" file navigation
nnoremap <silent> <Leader>f :SmartFiles<CR>

" more sane line navigation
nnoremap j gj
nnoremap k gk

" buffer navigation
nnoremap <silent> <Backspace> <C-^>
nnoremap <silent> <Leader>l :Buffers<CR>
nnoremap <silent> <Leader>{ :bprevious<CR>
nnoremap <silent> <Leader>} :bnext<CR>
nnoremap <silent> Q :bprevious <Bar> bdelete #<CR>
nnoremap <silent> <Leader>; :BLines<CR>
nnoremap <silent> <Leader>: :Lines<CR>

" tab navigation
nnoremap <silent> <Leader>[ :tabp<CR>
nnoremap <silent> <Leader>] :tabn<CR>

" tag jumping/previewing
nnoremap <silent> <Leader>k :BTags<CR>

" faster commenting
nmap <silent> <Leader>/ gcc
vmap <silent> <Leader>/ gc

" faster renaming
nnoremap <silent> <Leader>r *``cgn
nnoremap <silent> <Leader>gr g*``cgn
nnoremap <silent> <Leader>s :s/<C-r><C-w>/
xnoremap <silent> <Leader>s :s/

" session management
nnoremap <silent> <Leader>vs :SaveSession<CR>
function! s:SaveSession() abort
    if getcwd() =~ '/' . gina#component#repo#name() . '$'
        let branch = gina#component#repo#branch()
        if branch ==# ''
            mksession!
        else
            let _ = system('mkdir -p .git/sessions')
            execute 'mksession! .git/sessions/' . branch . '.vim'
        endif
    else
        echo 'SaveSession only works in the root .git directory'
    endif
endfunction
command! SaveSession call s:SaveSession()

" vim-cutlass pipes all deletes to the blackhole register, restore some of
" them under a new mapping
nnoremap <Leader>d d
xnoremap <Leader>d d

" repeat macro on selection
xnoremap <silent> . :norm.<CR>

" additional readline (emacs) mappings that vim-rsi doesn't cover
inoremap <C-k> <C-o>C
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

" this is never intentional
cnoremap w' w

" edit/save vimrc
nmap <silent> <Leader>ve :e ~/.config/nvim/init.vim<CR>
nmap <silent> <Leader>vr :source ~/.config/nvim/init.vim<CR>
" }}}

" PLUGIN SETTINGS {{{
" vim-qf {{{
let g:qf_mapping_ack_style = 1

nmap <silent> <Leader>qq <Plug>(qf_qf_toggle)
nmap <silent> [q :cprev<CR>
nmap <silent> ]q :cnext<CR>

augroup QF
    autocmd Filetype qf nnoremap <silent> <buffer> dd 0:Reject<CR>
    autocmd Filetype qf nnoremap <silent> <buffer> <Backspace> <Nop>
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
nmap <silent> ga <Plug>(EasyAlign)
xmap <silent> ga <Plug>(EasyAlign)
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
nmap <silent> gs <Plug>(GrepperOperator)
xmap <silent> gs <Plug>(GrepperOperator)
" }}}

" ale {{{
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_text_changed = 'never'
let g:ale_set_highlights = 0
let g:ale_sign_error = '!!'
let g:ale_sign_warning = '!!'

let g:ale_linters = {
            \ 'haskell': ['stack-build', 'hlint'],
            \ }
let g:ale_fixers = {
            \ '*': ['remove_trailing_lines', 'trim_whitespace'],
            \ 'elixir': ['mix_format'],
            \ 'haskell': [{_ -> { 'command': 'ormolu --mode inplace %t', 'read_temporary_file': 1 }}],
            \ 'python': ['black'],
            \ 'rust': 'rustfmt',
            \ }
let g:ale_fix_on_save = 1

let g:ale_python_auto_pipenv = 1

let g:ale_rust_cargo_use_clippy = 1

augroup LSP
    autocmd!
    autocmd Filetype rust nmap <silent> <buffer> <Leader>d <Plug>(ale_go_to_definition)
    autocmd Filetype rust nmap <silent> <buffer> <Leader>h <Plug>(ale_hover)
    autocmd Filetype rust setlocal omnifunc=ale#completion#OmniFunc
augroup END

nmap <silent> <C-k> <Plug>(ale_previous)
nmap <silent> <C-j> <Plug>(ale_next)
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

function! s:FzfStatusLine() abort
    setlocal statusline=%#StatusLine#\ »\ fzf
endfunction

command! SmartFiles execute (len(system('git rev-parse')) ? ':Files' : ':GFiles')
command! -bang Dotfiles call fzf#vim#files('~/.dotfiles', <bang>0)

augroup FZF
    autocmd! User FzfStatusLine call <SID>FzfStatusLine()
augroup END

" insert mode completions
inoremap <expr> <c-x><c-k> fzf#vim#complete#word()
inoremap <expr> <c-x><c-l> fzf#vim#complete#line()
" }}}

" elm-vim {{{
let g:elm_setup_keybindings = 0
" }}}

" notational-fzf-vim {{{
let g:nv_search_paths = ['~/notes']

nnoremap <Leader>j :NV!<CR>
" }}}

" vim-ruby {{{
let ruby_foldable_groups = 'def class module do case'
" }}}

" vim-signify {{{
let g:signify_vcs_list = ['git']
" }}}

" vim-yoink {{{
nmap <c-n> <plug>(YoinkPostPasteSwapBack)
nmap <c-p> <plug>(YoinkPostPasteSwapForward)

nmap p <plug>(YoinkPaste_p)
nmap P <plug>(YoinkPaste_P)

nmap <c-=> <plug>(YoinkPostPasteToggleFormat)

nmap y <plug>(YoinkYankPreserveCursorPosition)
xmap y <plug>(YoinkYankPreserveCursorPosition)

let g:yoinkIncludeDeleteOperations = 1
let g:yoinkAutoFormatPaste = 1
" }}}

" vim-subversive {{{
nmap s <plug>(SubversiveSubstitute)
nmap ss <plug>(SubversiveSubstituteLine)
nmap S <plug>(SubversiveSubstituteToEndOfLine)
" }}}

" }}}

" LANGUAGE AUTO GROUPS {{{
augroup BASH
    autocmd!
    autocmd Filetype sh setlocal iskeyword+=-
augroup END

augroup GOLANG
    autocmd!
    autocmd FileType go setlocal foldenable foldmethod=syntax
augroup END

augroup HASKELL
    autocmd!
    autocmd Filetype haskell setlocal shiftwidth=2 softtabstop=2
augroup END

augroup JSON
    autocmd!
    autocmd Filetype json nmap <silent> <buffer> <Leader>fp :%!jq<CR>
augroup END

augroup RUST
    autocmd!
    autocmd Filetype rust nmap <silent> <buffer> <C-]> <Plug>(rust-def)
    autocmd Filetype rust nmap <silent> <buffer> K <Plug>(rust-doc)
augroup END

augroup VIMRC
    autocmd!
    autocmd Filetype vim setlocal foldenable foldmethod=marker
augroup END
" }}}

runtime local.vim
