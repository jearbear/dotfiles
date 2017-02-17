"
" LEADER KEYS
"
let mapleader = " "
let maplocalleader = " "

"
" PLUGINS
"
call plug#begin('~/.config/nvim/plugged')

Plug 'morhetz/gruvbox'
Plug 'rakr/vim-one'
Plug 'joshdick/onedark.vim'

Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-unimpaired'

Plug 'junegunn/vim-easy-align'
Plug 'tpope/vim-surround'

Plug 'tpope/vim-fugitive'
" Plug 'mhinz/vim-signify'
Plug 'editorconfig/editorconfig-vim'
Plug 'justinmk/vim-dirvish'
Plug 'mhinz/vim-grepper'
Plug 'romainl/vim-qf'

Plug 'davidhalter/jedi-vim'
Plug 'neovimhaskell/haskell-vim'
Plug 'pangloss/vim-javascript'
Plug 'ternjs/tern_for_vim', { 'do': 'npm install' }
Plug 'lervag/vimtex'

Plug 'neomake/neomake'
Plug 'wellle/targets.vim'
Plug 'lifepillar/vim-mucomplete'

" Plug 'mhinz/vim-sayonara'
" Plug 'junegunn/goyo.vim'
Plug 'rust-lang/rust.vim'
Plug 'racer-rust/vim-racer'

" Plug 'vim-pandoc/vim-pandoc-syntax'
" Plug 'vim-pandoc/vim-pandoc'
Plug 'plasticboy/vim-markdown'

call plug#end()

"
" VISUAL SETTINGS
"
set background=dark
set termguicolors

" gruvbox
let g:gruvbox_invert_selection = 0
let g:gruvbox_italic = 1
let g:gruvbox_contrast_dark = 'soft'

colorscheme gruvbox

set hidden

set tabstop=2 shiftwidth=2 softtabstop=2 expandtab

set number

set wrap linebreak
set breakindent showbreak=..

set cole=2 cocu="n"

set incsearch nohlsearch
set ignorecase smartcase

set dictionary+=/usr/share/dict/words

set wildmenu wildignorecase
set wildignore+=*.o,tags,.git
set suffixes+=,,
set wildmode=full,full

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

let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1

"
" VIM SETTINGS
"
map Y y$
map 0 ^

nnoremap <Leader>, :tabp<CR>
nnoremap <Leader>. :tabn<CR>

set path=.,**
set wildcharm=<C-z>
nnoremap <Leader>f :find *
nnoremap <Leader>t :tabfind *
nnoremap <Leader>l :buffer <C-z><S-Tab>
nnoremap <Backspace> <C-^>
nnoremap Q :bd<CR>

nnoremap <Leader>j :tjump /
nnoremap <Leader>k :ptjump /

nmap <Leader>/ gcc
vmap <Leader>/ gc

nnoremap <Leader>r *``cgn
nnoremap <Leader>gr g*``cgn

xnoremap . :norm.<CR>

cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

inoremap {<CR> {<CR>}<Esc>O
inoremap {; {<CR>};<Esc>O

inoremap <C-c> <Esc>`^

nmap <Leader>v :e ~/.config/nvim/init.vim<CR>
nmap <Leader>V :source ~/.config/nvim/init.vim<CR>

"
" PLUGIN SETTINGS
"

" qf
nmap <C-f> <Plug>QfSwitch
let g:qf_mapping_ack_style = 1

" dirvish
let g:dirvish_relative_paths = 1

" editorconfig
let g:EditorConfig_core_mode = 'python_external'
let g:EditorConfig_exclude_patterns = ['fugitive://.*']
let g:EditorConfig_max_line_indicator = 'none'

" fugitive
nnoremap <Leader>gs :Gstatus<CR>

" easy align
nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)

" vim grepper
nnoremap \ :Grepper<CR>
nmap gs <Plug>(GrepperOperator)
xmap gs <Plug>(GrepperOperator)

" neomake
nnoremap <Leader>m :Neomake<CR>:silent !ctags -R .<CR>
let g:neomake_open_list = 2
let g:neomake_error_sign = {'text': '*', 'texthl': 'NeomakeErrorSign'}
let g:neomake_warning_sign = {'text': '!', 'texthl': 'NeomakeWarningSign'}
let g:neomake_message_sign = {'text': '>', 'texthl': 'NeomakeMessageSign'}
let g:neomake_info_sign = {'text': 'i', 'texthl': 'NeomakeInfoSign'}

" vim sneak
let g:sneak#streak = 1

" jedi
let g:jedi#auto_initialization = 0
autocmd FileType python setlocal omnifunc=jedi#completions

" targets
let g:targets_seekRanges = 'cr cb cB lc ac Ac lr rr ll lb ar ab lB Ar aB Ab AB rb rB al Al'

" vimwiki
let g:vimwiki_list = [{'path': '~/wiki/',
            \ 'syntax': 'markdown', 'ext': '.md'}]

" rust racer
let g:racer_experimental_completer = 1
