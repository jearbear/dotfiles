"
" LEADER KEYS
"
let mapleader = " "
let maplocalleader = " "


"
" PLUGINS
"
call plug#begin('~/.config/nvim/plugged')

" themes
Plug 'morhetz/gruvbox'

" mappings
Plug 'junegunn/vim-easy-align'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'wellle/targets.vim'
Plug 'AndrewRadev/splitjoin.vim'

" version control
Plug 'mhinz/vim-signify'
Plug 'lambdalisue/gina.vim'

" project management
Plug 'romainl/vim-qf'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-sleuth'
Plug 'dense-analysis/ale'

" completion
Plug 'racer-rust/vim-racer'
Plug 'tpope/vim-endwise'
Plug 'rstacruz/vim-closer'

" project navigation
Plug 'justinmk/vim-dirvish'
Plug 'mhinz/vim-grepper'
Plug 'ludovicchabant/vim-gutentags'

" language support
Plug 'ElmCast/elm-vim'
Plug 'cespare/vim-toml'
Plug 'fatih/vim-go'
Plug 'neovimhaskell/haskell-vim'
Plug 'pangloss/vim-javascript'
Plug 'rodjek/vim-puppet'
Plug 'rust-lang/rust.vim'
Plug 'vim-ruby/vim-ruby'
Plug 'jamessan/vim-gnupg'
Plug 'rgrinberg/vim-ocaml'
Plug 'Glench/Vim-Jinja2-Syntax'
Plug 'tpope/vim-ragtag'

" notational velocity
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'Alok/notational-fzf-vim'

" fzf
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

call plug#end()


"
" VISUAL SETTINGS
"
set background=dark
set termguicolors

let g:gruvbox_contrast_dark = 'soft'
let g:gruvbox_contrast_light = 'soft'
let g:gruvbox_invert_selection = 0
let g:gruvbox_italic = 1

colorscheme gruvbox

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

set dictionary+=/usr/share/dict/words

" prefer files with suffixes (deprioritize binaries)
set suffixes+=,,

set wildignore+=*.pyc,*.swp,*.lock,*.min.js,*.min.css,tags
set wildignore+=*/tmp/*,*/target/*,*/venv/*,*/vendor/*,*/elm-stuff/*,*/bazel*/*,*/build/*
set wildmenu wildignorecase
set wildmode=full,full

" no completion messages
set shortmess+=c
set completeopt=menu,menuone

hi StatusLine   guibg=#928374 guifg=#3c3836
hi StatusLineNC guibg=#665c54 guifg=#3c3836
hi WildMenu     guibg=#3c3836
hi User1        guibg=#3c3836 guifg=#665c54
hi User2        guibg=#3c3836 guifg=#83a598

hi DiffAdd    guifg=NONE    guibg=#4D4B2D gui=NONE
hi DiffChange guifg=NONE    guibg=#5A4C2F gui=NONE
hi DiffDelete guifg=#823930 guibg=#5A3430 gui=NONE
hi DiffText   guifg=#fabd2f guibg=#65532E gui=NONE

set statusline=\ \                              " padding
set statusline+=%f                              " filename
set statusline+=\ %2*%M%*                       " modified flag
set statusline+=%=                              " center divide
set statusline+=%{gina#component#repo#branch()} " vcs info
set statusline+=\ \                             " padding

set spelllang=en

set backupdir=~/.config/nvim/backup//
set directory=~/.config/nvim/swp//

" auto read/write file on enter/jump
set noswapfile autoread autowrite       
autocmd! FocusGained,BufEnter * checktime

" default to bash filetype for ft=sh
let g:is_bash = 1


"
" VIM SETTINGS
"
map Y y$
map 0 ^

" file navigation
nnoremap <Leader>f :Files<CR>

" buffer navigation
nnoremap <Backspace> <C-^>
nnoremap <Leader>l :Buffers<CR>

nnoremap <Leader>[ :bprevious<CR>
nnoremap <Leader>] :bnext<CR>
nnoremap Q :bd<CR>

" tab navigation
nnoremap <Leader>} :tabp<CR>
nnoremap <Leader>{ :tabn<CR>

" tag jumping/previewing
nnoremap <Leader>j :Tags<CR>
nnoremap <Leader>k :BTags<CR>

" mark navigation
nnoremap <Leader>m :Marks<CR>

" faster commenting
nmap <Leader>/ gcc
vmap <Leader>/ gc

" variable renaming
nnoremap <Leader>r *``cgn
nnoremap <Leader>gr g*``cgn

" gv for pasted text
nnoremap gp `[v`]

" repeat macro on selection
xnoremap . :norm.<CR>

" emacs-like command mode navigation
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>

" quickly substitute
nnoremap g/ :%s//g<Left><Left>
xnoremap g/ :s//g<Left><Left>

" edit/save vimrc
nmap <Leader>ve :e ~/.config/nvim/init.vim<CR>
nmap <Leader>vs :source ~/.config/nvim/init.vim<CR>

" nicer tabline
function! Tabline()
    let s = ''
    for i in range(tabpagenr('$'))
        let tab = i + 1
        let winnr = tabpagewinnr(tab)
        let buflist = tabpagebuflist(tab)
        let bufnr = buflist[winnr - 1]
        let bufname = bufname(bufnr)
        let bufmodified = getbufvar(bufnr, "&mod")

        let s .= '%' . tab . 'T'
        let s .= (tab == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#')
        let s .= ' ' . len(buflist) .' - '
        let s .= (bufname != '' ? fnamemodify(bufname, ':t') . ' ' : '[No Name] ')

        if bufmodified
            let s .= '[+] '
        endif
    endfor

    let s .= '%#TabLineFill#'

    return s
endfunction
set tabline=%!Tabline()


"
" PLUGIN SETTINGS
"
" vim-qf
let g:qf_mapping_ack_style = 1
nmap <Leader>qw <Plug>(qf_qf_switch)
nmap <Leader>qq <Plug>(qf_qf_toggle)
nmap [q <Plug>(qf_qf_previous)
nmap ]q <Plug>(qf_qf_next)
autocmd Filetype qf nnoremap <buffer> dd 0:Reject<CR>
autocmd Filetype qf nnoremap <buffer> <Backspace> <Nop>

" gina.vim
nnoremap <Leader>gs :Gina status<CR>
nnoremap <Leader>gd :Gina compare :<CR>
nnoremap <Leader>gb :Gina blame --width=35 :<CR>
nnoremap <Leader>gh :.Gina browse : --exact<CR>
xnoremap <Leader>gh :Gina browse : --exact<CR>
nnoremap <Leader>gl "+:.Gina browse : --yank --exact<CR>
xnoremap <Leader>gl "+:Gina browse : --yank --exact<CR>

let g:gina#component#repo#commit_length = 10
let g:gina#command#blame#formatter#format = "%au%=on %ti %ma%in"

" vim-easy-align
nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)

" vim-grepper
nnoremap \ :Grepper<CR>
nmap gs <Plug>(GrepperOperator)
xmap gs <Plug>(GrepperOperator)

let g:grepper = {}
let g:grepper.simple_prompt = 1
let g:grepper.prompt_quote = 2
let g:grepper.switch = 1
let g:grepper.tools = ['rg', 'git', 'grep']
let g:grepper.stop = 1000

" ale
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_text_changed = 'never'
let g:ale_set_highlights = 0
let g:ale_sign_error = '!!'
let g:ale_sign_warning = '!!'

let g:ale_fixers = {
            \ 'haskell': 'hfmt',
            \ 'ocaml': 'ocamlformat',
            \ 'rust': 'rustfmt',
            \ }
let g:ale_fix_on_save = 1

let g:ale_rust_cargo_use_clippy = 1

hi link ALEErrorSign GruvboxRedSign
hi link ALEWarningSign GruvboxYellowSign

nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

" targets.vim
let g:targets_seekRanges = 'cc cr cb cB lc ac Ac lr lb ar ab lB Ar aB Ab AB rr ll'

" vim-slime
let g:slime_target = "tmux"

" racer
let g:racer_experimental_completer = 1

" vim-go
let g:go_fmt_command = 'goimports'
let g:go_list_type = 'quickfix'
let g:go_fold_enable = ['import']

" vim-gutentags
let g:gutentags_generate_on_empty_buffer = 1

" fzf.vim
let g:fzf_layout = { 'down': 10 }
let g:fzf_history_dir = '~/.fzf-history'
let g:fzf_action = {
            \ 'ctrl-p': 'pedit',
            \ 'ctrl-t': 'tab split',
            \ 'ctrl-s': 'split',
            \ 'ctrl-v': 'vsplit',
            \ }
let g:fzf_colors = {
            \ 'fg':      ['fg', 'Comment'],
            \ 'bg':      ['bg', 'Normal'],
            \ 'hl':      ['fg', 'Type'],
            \ 'fg+':     ['fg', 'Normal'],
            \ 'bg+':     ['bg', 'Normal'],
            \ 'hl+':     ['fg', 'Type'],
            \ 'info':    ['fg', 'Constant'],
            \ 'prompt':  ['fg', 'Type'],
            \ 'pointer': ['fg', 'Constant'],
            \ 'marker':  ['fg', 'Constant'],
            \ 'spinner': ['fg', 'Constant'],
            \ 'header':  ['fg', 'PmenuSel'],
            \ }

function! s:fzf_statusline() abort
    setlocal statusline=%#StatusLine#\ »\ fzf
endfunction
autocmd! User FzfStatusLine call <SID>fzf_statusline()

" get the shortened cwd
function! s:shortpath()
    let short = pathshorten(fnamemodify(getcwd(), ':~:.'))
    let slash = '/'
    return empty(short) ? '~'.slash : short . (short =~ escape(slash, '\').'$' ? '' : slash)
endfunction

" faster implementation of Files/GFiles that works outside of git repos
command! Files call fzf#run(fzf#wrap({'source': 'git ls-files || fd -t file', 'options': ['--prompt', s:shortpath()]}))

" elm-vim
let g:elm_setup_keybindings = 0

" vim-signify
let g:signify_vcs_list = ['git']

" notational-fzf-vim
nnoremap <Leader>\ :NV<CR>
let g:nv_search_paths = ['~/sync/notes']
let g:nv_use_short_pathnames = 1
let g:nv_create_note_window = 'edit'


" 
" LANGUAGE SETTINGS
"
augroup Golang
    autocmd!

    autocmd FileType go setlocal foldenable foldmethod=syntax
augroup END

augroup Haskell
    autocmd!

    autocmd FileType haskell hi link haskellSeparator GruvboxFg4
    autocmd FileType haskell hi link haskellDelimiter GruvboxOrange
    autocmd FileType haskell hi link haskellPragma GruvboxRedBold
augroup END

augroup Ocaml
    autocmd!

    " ocp-indent must be before merlin for some reason
    autocmd Filetype ocaml setlocal runtimepath^=~/.opam/default/share/merlin/vim
    autocmd Filetype ocaml setlocal runtimepath^=~/.opam/default/share/ocp-indent/vim

    autocmd Filetype ocaml let no_ocaml_maps=1 " disable vim-ocaml mappings
    autocmd Filetype ocaml nnoremap <buffer> <C-]> :MerlinLocate<CR>
augroup END

augroup Rust
    autocmd!

    autocmd Filetype rust nmap <C-]> <Plug>(rust-def)
    autocmd Filetype rust nmap K <Plug>(rust-doc)
augroup END

augroup Tera
    autocmd!

    autocmd BufRead *.tera set ft=jinja.html
augroup END

augroup Markdown
    autocmd!

    autocmd Filetype markdown nnoremap <Leader>t :TableFormat<CR>
augroup END

augroup Racket
    autocmd!

    autocmd BufRead,BufNewFile *.rkt,*.rktl set ft=racket
augroup END


"
" SOURCE LOCAL SETTINGS
"
runtime local.vim
