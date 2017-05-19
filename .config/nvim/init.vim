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
Plug 'joshdick/onedark.vim'
Plug 'morhetz/gruvbox'
Plug 'rakr/vim-one'

" mappings
Plug 'junegunn/vim-easy-align'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'wellle/targets.vim'
Plug 'justinmk/vim-sneak'

" code wrangling
Plug 'editorconfig/editorconfig-vim'
Plug 'w0rp/ale'
Plug 'romainl/vim-qf'
Plug 'tpope/vim-fugitive'

" completion
Plug 'KeyboardFire/vim-minisnip'
Plug 'lifepillar/vim-mucomplete'
Plug 'mattn/emmet-vim'

" navigation
Plug 'justinmk/vim-dirvish'
Plug 'mhinz/vim-grepper'

" language support
Plug 'cespare/vim-toml'
Plug 'godlygeek/tabular'
Plug 'lervag/vimtex'
Plug 'neovimhaskell/haskell-vim'
Plug 'pangloss/vim-javascript'
Plug 'plasticboy/vim-markdown'
Plug 'racer-rust/vim-racer'
Plug 'rust-lang/rust.vim'
Plug 'tweekmonster/braceless.vim'

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

set tabstop=2 shiftwidth=2 softtabstop=2 expandtab

set number

set wrap linebreak
set breakindent showbreak=..

set cole=2 cocu=n
set nofoldenable

set inccommand=nosplit
set incsearch nohlsearch
set ignorecase smartcase

set dictionary+=/usr/share/dict/words

" prefer files with suffixes
set suffixes+=,,
set wildignore+=*.pyc,*.swp,tags
set wildignore+=*/.git/*,*/tmp/*,*/target/*,*/venv/*
set wildmenu wildignorecase
set wildmode=full,full

" no completion messages
set shortmess+=c
set completeopt=menu,menuone,preview
autocmd CompleteDone * pclose

hi StatusLine   guibg=#928374 guifg=#3c3836
hi StatusLineNC guibg=#665c54 guifg=#3c3836
hi WildMenu     guibg=#3c3836
hi User1        guibg=#3c3836 guifg=#665c54
hi User2        guibg=#3c3836 guifg=#83a598

set statusline=\ \                 " padding
set statusline+=%f                 " filename
set statusline+=\ %2*%M%*          " modified flag
set statusline+=%=                 " center divide
set statusline+=%{fugitive#head()} " vcs info
set statusline+=\ \                " padding

set spelllang=en

set backupdir=~/.config/nvim/backup//
set directory=~/.config/nvim/swp//


"
" VIM SETTINGS
"
map Y y$
map 0 ^

" break a habit
inoremap <C-c> <nop>

" file navigation
set path=.,**
set wildcharm=<C-z>
nnoremap <Leader>f :find *

" buffer navigation
nnoremap <Backspace> <C-^>
nnoremap <Leader>l :buffer <C-z><S-Tab>
nnoremap Q :bd<CR>

" tab navigation
nnoremap <Leader>, :tabp<CR>
nnoremap <Leader>. :tabn<CR>

" tag jumping/previewing
nnoremap <Leader>j :tjump /
nnoremap <Leader>k :ptjump /

" faster commenting
nmap <Leader>/ gcc
vmap <Leader>/ gc

" chance and replace
nnoremap <Leader>r *``cgn
nnoremap <Leader>gr g*``cgn

" repeat macro on selection
xnoremap . :norm.<CR>

" sensible command line navigation
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

" brace completion
inoremap {<CR> {<CR>}<Esc>O
inoremap {; {<CR>};<Esc>O
inoremap {, {<CR>},<Esc>O
inoremap {); {<CR>});<Esc>O
inoremap {)<CR> {<CR>})<Esc>O

" edit/save vimrc
nmap <Leader>v :e ~/.config/nvim/init.vim<CR>
nmap <Leader>V :source ~/.config/nvim/init.vim<CR>

" generate tags
nnoremap <Leader>t :silent !ctags -R --exclude=@.ctagsignore<CR>


"
" PLUGIN SETTINGS
"
" vim-qf
let g:qf_mapping_ack_style = 1
nmap <C-q> <Plug>(qf_qf_switch)
nmap <C-l> <Plug>(qf_qf_toggle)

" vim-dirvish
let g:dirvish_relative_paths = 1

" editorconfig-vim
let g:EditorConfig_core_mode = 'python_external'
let g:EditorConfig_exclude_patterns = ['fugitive://.*']
let g:EditorConfig_max_line_indicator = 'none'

" vim-fugitive
nnoremap <Leader>gs :Gstatus<CR>

" vim-easy-align
nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)

" vim-grepper
nnoremap \ :Grepper<CR>
map gs <Plug>(GrepperOperator)
nmap gs <Plug>(GrepperOperator)
let g:grepper = {}
let g:grepper.simple_prompt = 1
let g:grepper.tools = ['rg', 'git', 'grep']

" ale
let g:ale_sign_error = '!!'
let g:ale_sign_warning = '!!'
let g:ale_set_highlights = 0
let g:ale_lint_on_text_changed = 'never'
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1

hi link ALEErrorSign GruvboxRedSign
hi link ALEWarningSign GruvboxYellowSign

nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

" targets.vim
let g:targets_seekRanges = 'cr cb cB lc ac Ac lr rr ll lb ar ab lB Ar aB Ab AB rb rB al Al'

" racer
let g:racer_experimental_completer = 1
autocmd FileType rust nmap gd <Plug>(rust-def)
autocmd FileType rust nmap <Leader>gd <Plug>(rust-doc)

" braceless.vim
autocmd FileType python BracelessEnable +indent

" emmet-vim
let g:user_emmet_leader_key = '<C-f>'

" vim-minisnip
let g:minisnip_dir = '~/.config/nvim/minisnip'
let g:minisnip_trigger = '<C-j>'

" vim-mucomplete
inoremap <silent> <plug>(MUcompleteFwdKey) <right>
imap <right> <plug>(MUcompleteCycFwd)
inoremap <silent> <plug>(MUcompleteBwdKey) <left>
imap <left> <plug>(MUcompleteCycBwd)

" vim-sneak
let g:sneak#use_ic_scs = 1
