" LEADER KEYS {{{
let mapleader = ' '
let maplocalleader = ' '
" }}}

" PLUGINS {{{
call plug#begin('~/.config/nvim/plugged')

" themes
Plug 'rakr/vim-one'

" mappings
Plug 'AndrewRadev/splitjoin.vim'
Plug 'junegunn/vim-easy-align'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'wellle/targets.vim'

" version control
Plug 'lambdalisue/gina.vim'
Plug 'mhinz/vim-signify'

" project management
Plug 'dense-analysis/ale'
Plug 'jpalardy/vim-slime'
Plug 'romainl/vim-qf'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-sleuth'

" completion
Plug 'racer-rust/vim-racer', { 'for': 'rust' }
Plug 'rstacruz/vim-closer'
Plug 'tpope/vim-endwise'

" project navigation
Plug 'justinmk/vim-dirvish'
Plug 'ludovicchabant/vim-gutentags'
Plug 'mhinz/vim-grepper'

" language support
Plug 'ElmCast/elm-vim', { 'for': 'elm' }
Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh' }
Plug 'cespare/vim-toml', { 'for': 'toml' }
Plug 'fatih/vim-go', { 'for': 'go', 'do': ':GoInstallBinaries' }
Plug 'godlygeek/tabular', { 'for': 'markdown' }
Plug 'neovimhaskell/haskell-vim'
Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
Plug 'rodjek/vim-puppet', { 'for': 'puppet' }
Plug 'rust-lang/rust.vim', { 'for': 'rust' }
Plug 'tpope/vim-ragtag', { 'for': 'html' }
Plug 'vim-ruby/vim-ruby', { 'for': 'ruby' }

" fzf
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

call plug#end()
" }}}

" COLOR SCHEME {{{
set background=light
set termguicolors

let g:one_allow_italics = 1

colorscheme one
" }}}

" VISUAL SETTINGS {{{
set hidden

set shiftwidth=4 softtabstop=4 expandtab

set cursorline
set scrolljump=-50

" more useful <C-G> with line number
set noruler

set nojoinspaces

set wrap linebreak
set breakindent showbreak=..

set nofoldenable
set conceallevel=2 concealcursor="nc"

set inccommand=nosplit
set incsearch nohlsearch
set ignorecase smartcase

" prefer files with suffixes (deprioritize binaries)
set suffixes+=,,

set wildignore+=*.pyc,*.swp,*.lock,*.min.js,*.min.css,tags
set wildignore+=*/tmp/*,*/target/*,*/venv/*,*/vendor/*,*/elm-stuff/*,*/bazel*/*,*/build/*
set wildmenu wildignorecase
set wildmode=full,full

" no completion messages
set shortmess+=c
set completeopt=menu,menuone

hi StatusLine   gui=bold guibg=#ececec
hi StatusLineNC gui=NONE guifg=DarkGray guibg=#ececec

set statusline=\ \                              " padding
set statusline+=%f                              " filename
set statusline+=\ %M%*                          " modified flag
set statusline+=%=                              " center divide
set statusline+=%{gina#component#repo#branch()} " vcs info
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

" }}}

" VIM SETTINGS {{{
set spelllang=en
set dictionary+=/usr/share/dict/words

silent !mkdir ~/.config/nvim/backup// > /dev/null 2>&1
silent !mkdir ~/.config/nvim/swp// > /dev/null 2>&1
set backupdir=~/.config/nvim/backup//
set directory=~/.config/nvim/swp//

" allow jumping to filename:linenum
set isfname-=:

" auto read/write file on enter/jump
set noswapfile autoread autowrite
augroup AutoReadWrite
    autocmd! FocusGained,BufEnter * checktime
augroup END

" default to bash filetype for ft=sh
let g:is_bash = 1
" }}}

" MAPPINGS {{{
map <silent> Y y$
map <silent> 0 ^

" file navigation
nnoremap <silent> <Leader>f :Files<CR>
nnoremap <silent> <Leader>F :GFiles<CR>

" buffer navigation
nnoremap <silent> <Backspace> <C-^>
nnoremap <silent> <Leader>l :Buffers<CR>
nnoremap <silent> <Leader>[ :bprevious<CR>
nnoremap <silent> <Leader>] :bnext<CR>
nnoremap <silent> Q :bprevious <Bar> bdelete #<CR>

" tab navigation
nnoremap <silent> <Leader>{ :tabp<CR>
nnoremap <silent> <Leader>} :tabn<CR>

" tag jumping/previewing
nnoremap <silent> <Leader>j :Tags<CR>
nnoremap <silent> <Leader>k :BTags<CR>

" faster commenting
nmap <silent> <Leader>/ gcc
vmap <silent> <Leader>/ gc

" faster renaming
nnoremap <silent> <Leader>r *``cgn
nnoremap <silent> <Leader>gr g*``cgn
nnoremap <silent> <Leader>s :s/<C-r><C-w>/
xnoremap <silent> <Leader>s :s/

" gv for pasted text
nnoremap <silent> gp `[v`]

" replace selected text without yanking it
vnoremap <silent> <Leader>p "_dP

" repeat macro on selection
xnoremap <silent> . :norm.<CR>

" emacs-like command mode navigation
cnoremap <silent> C-a> <Home>
cnoremap <silent> <C-e> <End>
cnoremap <silent> <C-p> <Up>
cnoremap <silent> <C-n> <Down>
cnoremap <silent> <C-b> <Left>
cnoremap <silent> <C-f> <Right>

" edit/save vimrc
nmap <silent> <Leader>ve :e ~/.config/nvim/init.vim<CR>
nmap <silent> <Leader>vs :source ~/.config/nvim/init.vim<CR>
" }}}

" PLUGIN SETTINGS {{{
" vim-qf {{{
let g:qf_mapping_ack_style = 1

nmap <silent> <Leader>qq <Plug>(qf_qf_toggle)
nmap <silent> [q :cprev<CR>
nmap <silent> ]q :cnext<CR>

augroup Qf
    autocmd Filetype qf nnoremap <silent> <buffer> dd 0:Reject<CR>
    autocmd Filetype qf nnoremap <silent> <buffer> <Backspace> <Nop>
augroup END
" }}}

" gina.vim {{{
nnoremap <silent> <Leader>gs :Gina status<CR>
nnoremap <silent> <Leader>gb :.Gina browse : --exact --scheme=blame<CR>
nnoremap <silent> <Leader>gh :.Gina browse : --exact<CR>
xnoremap <silent> <Leader>gh :Gina browse : --exact<CR>
nnoremap <silent> <Leader>gl "+:.Gina browse : --yank --exact<CR>
xnoremap <silent> <Leader>gl "+:Gina browse : --yank --exact<CR>
" }}}

" vim-easy-align {{{
nmap <silent> ga <Plug>(EasyAlign)
xmap <silent> ga <Plug>(EasyAlign)
" }}}

" vim-grepper {{{
runtime plugin/grepper.vim
let g:grepper.simple_prompt = 1
let g:grepper.switch = 0
let g:grepper.tools = ['rg', 'git']
let g:grepper.stop = 1000

nnoremap <silent> \ :Grepper<CR>
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
            \ 'haskell': ['stack-build'],
            \ }
let g:ale_fixers = {
            \ '*': ['remove_trailing_lines', 'trim_whitespace'],
            \ 'rust': 'rustfmt',
            \ }
let g:ale_fix_on_save = 1

let g:ale_rust_cargo_use_clippy = 1

nmap <silent> <C-k> <Plug>(ale_previous)
nmap <silent> <C-j> <Plug>(ale_next)
" }}}

" targets.vim {{{
" ranges on the cursor
let g:targets_seekRanges = 'cc cr cb cB lc ac Ac'
" range around the cursor, fully contained on the same line
let g:targets_seekRanges .= ' lr'
" range ahead of the cursor, fully contained on the same line
let g:targets_seekRanges .= ' rr'
" ranges around the cursor, multiline
let g:targets_seekRanges .= ' lb ar ab lB Ar aB Ab AB'
" ranges behind the cursor, fully contained on the same line
let g:targets_seekRanges .= ' ll'
" }}}

" racer {{{
let g:racer_experimental_completer = 1
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

" vim-gutentags {{{
let g:gutentags_generate_on_new = 0
" }}}

" fzf.vim {{{
let g:fzf_layout = { 'down': 10 }
let g:fzf_history_dir = '~/.fzf-history'
let g:fzf_action = {
            \ 'ctrl-t': 'tab split',
            \ 'ctrl-s': 'split',
            \ 'ctrl-v': 'vsplit',
            \ }

" helper methods {{{
function! s:fzf_statusline() abort
    setlocal statusline=%#StatusLine#\ »\ fzf
endfunction
augroup FZF
    autocmd! User FzfStatusLine call <SID>fzf_statusline()
augroup END

" get the shortened cwd
function! FZFPath()
    let short = pathshorten(fnamemodify(getcwd(), ':~:.'))
    let slash = '/'
    return empty(short) ? '~'.slash : short . (short =~ escape(slash, '\').'$' ? '' : slash)
endfunction
" }}}

" faster implementation of Files/GFiles that works outside of git repos
command! Files call fzf#run(fzf#wrap({'source': 'git ls-files | uniq || fd -t file', 'options': ['--prompt', FZFPath()]}))

nnoremap <silent> <Leader>\ :Lines<CR>
nnoremap <silent> <bar> :Rg<CR>
" }}}

" elm-vim {{{
let g:elm_setup_keybindings = 0
" }}}

" vim-signify {{{
let g:signify_vcs_list = ['git']
" }}}

" vim-ruby {{{
let ruby_foldable_groups = 'def class module do case'
" }}}
" }}}

" LANGUAGE AUTO GROUPS {{{
augroup golang
    autocmd!
    autocmd FileType go setlocal foldenable foldmethod=syntax
augroup END

augroup json
    autocmd!
    autocmd Filetype json nmap <buffer> <Leader>fp :%!python -m json.tool<CR>
augroup END

augroup rust
    autocmd!
    autocmd Filetype rust nmap <buffer> <C-]> <Plug>(rust-def)
    autocmd Filetype rust nmap <buffer> K <Plug>(rust-doc)
augroup END

augroup vimrc
    autocmd!
    autocmd Filetype vim setlocal foldenable foldmethod=marker
augroup END
" }}}

runtime local.vim
