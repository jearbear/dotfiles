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

" version control
Plug 'mhinz/vim-signify'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'

" project management
Plug 'romainl/vim-qf'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-sleuth'
Plug 'w0rp/ale'

" completion
Plug 'racer-rust/vim-racer'
Plug 'tpope/vim-endwise'
Plug 'rstacruz/vim-closer'

" project navigation
Plug 'justinmk/vim-dirvish'
Plug 'ludovicchabant/vim-gutentags'
Plug 'mhinz/vim-grepper'

" language support
Plug 'ElmCast/elm-vim'
Plug 'cespare/vim-toml'
Plug 'fatih/vim-go'
Plug 'lervag/vimtex'
Plug 'neovimhaskell/haskell-vim'
Plug 'pangloss/vim-javascript'
Plug 'plasticboy/vim-markdown'
Plug 'rodjek/vim-puppet'
Plug 'rust-lang/rust.vim'
Plug 'vim-ruby/vim-ruby'

" misc
Plug 'godlygeek/tabular'

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
let g:gruvbox_invert_selection = 0
let g:gruvbox_italic = 1

colorscheme gruvbox

set hidden

set shiftwidth=4 softtabstop=4 expandtab

set number
set cursorline
set scrolloff=5
set scrolljump=-33

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
set wildignore+=*/.git/*,*/tmp/*,*/target/*,*/venv/*,*/vendor/*,*/elm-stuff/*
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

hi DiffAdd guifg=NONE guibg=#4D4B2D gui=NONE
hi DiffChange guifg=NONE guibg=#5A4C2F gui=NONE
hi DiffDelete guifg=#823930 guibg=#5A3430 gui=NONE
hi DiffText guifg=#fabd2f guibg=#65532E gui=NONE

set statusline=\ \                   " padding
set statusline+=%f                   " filename
set statusline+=\ %2*%M%*            " modified flag
set statusline+=%=                   " center divide
set statusline+=%{fugitive#head(10)} " vcs info
set statusline+=\ \                  " padding

set spelllang=en

" set undofile
set backupdir=~/.config/nvim/backup//
set directory=~/.config/nvim/swp//

" auto read/write file on enter/jump
set noswapfile      
set autoread        
set autowrite       
autocmd! FocusGained,BufEnter * checktime

"
" VIM SETTINGS
"
map Y y$
map 0 ^

" file navigation
nnoremap <Leader>f :GFiles<CR>
nnoremap <Leader>F :Files<CR>

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

" faster commenting
nmap <Leader>/ gcc
vmap <Leader>/ gc

" variable renaming
nnoremap <Leader>r *``cgn
nnoremap <Leader>gr g*``cgn

" repeat macro on selection
xnoremap . :norm.<CR>

" sensible command line navigation
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

" quickly indent/format     
nnoremap g= gg=G``      

" quickly substitute with selection     
nnoremap gs :%s//g<Left><Left>      
xnoremap gs y:%s/<C-r>"//g<Left><Left>

" edit/save vimrc
nmap <Leader>ve :e ~/.config/nvim/init.vim<CR>
nmap <Leader>vs :source ~/.config/nvim/init.vim<CR>


"
" PLUGIN SETTINGS
"
" vim-qf
let g:qf_mapping_ack_style = 1
nmap <Leader>qw <Plug>qf_qf_switch
nmap <Leader>qq <Plug>qf_qf_toggle
nmap <Leader>qp <Plug>qf_qf_previous
nmap <Leader>qn <Plug>qf_qf_next

" vim-dirvish
let g:dirvish_relative_paths = 1

" vim-fugitive
nnoremap <Leader>gs :Gstatus<CR>
nnoremap <Leader>gl :Glog<CR>
nnoremap <Leader>gp :Gpush<CR>
nnoremap <Leader>gb :Gblame<CR>
nnoremap <Leader>gd :Gdiff<CR>
nnoremap <Leader>gh :Gbrowse<CR>
xnoremap <Leader>gh :Gbrowse<CR>
nnoremap <Leader>gc :Gbrowse!<CR>
xnoremap <Leader>gc :Gbrowse!<CR>

" vim-easy-align
nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)

" vim-grepper
nnoremap \ :Grepper<CR>
xmap <bar> <Plug>(GrepperOperator)
nmap <bar> <Plug>(GrepperOperator)

let g:grepper = {}
let g:grepper.simple_prompt = 1
let g:grepper.switch = 0
let g:grepper.tools = ['rg', 'git', 'grep']

" ale
let g:ale_sign_error = '!!'
let g:ale_sign_warning = '!!'
let g:ale_set_highlights = 0
let g:ale_set_quickfix = 1
let g:ale_lint_on_enter = 0
let g:ale_lint_on_text_changed = 'never'

let g:ale_linters = {'go': []}

let g:ale_fixers = {
            \ 'haskell': 'hfmt',
            \ 'rust': 'rustfmt',
            \ }
let g:ale_fix_on_save = 1

hi link ALEErrorSign GruvboxRedSign
hi link ALEWarningSign GruvboxYellowSign

nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

" targets.vim
let g:targets_seekRanges = 'cr cb cB lc ac Ac lr rr ll lb ar ab lB Ar aB Ab AB rb rB al Al'

" racer
let g:racer_experimental_completer = 1

" vim-go
let g:go_fmt_command = 'goimports'
let g:go_list_type = 'quickfix'
let g:go_fold_enable = ['import']

" vim-gutentags
let g:gutentags_cache_dir = '~/.gutentags'
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

" elm-vim
let g:elm_setup_keybindings = 0

" haskell-vim
" let g:haskell_indent_disable = 1
" let g:haskell_vim_indent_if = 4
" let g:haskell_vim_indent_case = 4
" let g:haskell_vim_indent_let = 4
" " let g:haskell_vim_indent_where = 
" " let g:haskell_vim_indent_before_where = 
" " let g:haskell_vim_indent_after_bare_where = 
" let g:haskell_vim_indent_do = 4
" let g:haskell_vim_indent_in = 0
" let g:haskell_vim_indent_guard = 

" vim-signify
let g:signify_vcs_list = ['git']


" 
" LANGUAGE SETTINGS
"
augroup Golang
    autocmd FileType go set foldenable
    autocmd FileType go set foldmethod=syntax
augroup END

augroup Haskell
    autocmd FileType haskell hi link haskellSeparator GruvboxFg4
    autocmd FileType haskell hi link haskellDelimiter GruvboxOrange
    autocmd FileType haskell hi link haskellPragma GruvboxRedBold
augroup END

augroup Rust
    autocmd FileType rust nmap gd <Plug>(rust-def)
    autocmd FileType rust nmap <Leader>gd <Plug>(rust-doc)
augroup END

augroup Tera
    au BufRead,BufNewFile *.tera set filetype=htmldjango
augroup END

"
" SOURCE LOCAL SETTINGS
"
runtime local.vim
