" ENV VARIABLES {{{
let $VIM_FILES=expand('~/.config/nvim')
" }}}

" LEADER KEYS {{{
let mapleader = ' '
let maplocalleader = ' '
" }}}

" PLUGINS {{{
call plug#begin('~/.config/nvim/plugged')

" themes
Plug 'RRethy/nvim-base16'        " properly sets colors for LSP highlights

" mappings
Plug 'AndrewRadev/splitjoin.vim' " language-aware splits and joins
Plug 'junegunn/vim-easy-align'   " easily vertically align text (like this!)
Plug 'tpope/vim-commentary'      " key bindings for commenting
Plug 'tpope/vim-rsi'             " Emacs bindings in command mode
Plug 'tpope/vim-surround'        " additional mappings to manipulate brackets
Plug 'tpope/vim-unimpaired'      " mostly use for [<Space> and ]<Space>
Plug 'wellle/targets.vim'        " additional text objects
Plug 'Asheq/close-buffers.vim'   " delete buffers without closing the window

" copy pasta
Plug 'svermeulen/vim-yoink'      " better handling of yanks (yank rings, auto-formatting)
Plug 'svermeulen/vim-subversive' " mappings to substitute text

" version control
Plug 'lambdalisue/gina.vim'      " git integration (show current branch, open in GH)
Plug 'mhinz/vim-signify'         " VCS change indicators in the gutter

" project management
Plug 'neomake/neomake'           " code linting
Plug 'romainl/vim-qf'            " slicker qf and loclist handling
Plug 'tpope/vim-eunuch'          " unix shell commands in command mode

" completion
Plug 'lifepillar/vim-mucomplete' " best-effort tab completion
Plug 'rstacruz/vim-closer'       " automatically close brackets
Plug 'tpope/vim-endwise'         " automatically close everything else

" project navigation
Plug 'justinmk/vim-dirvish'      " minimal file browser
Plug 'mhinz/vim-grepper'         " slicker grep support
Plug 'wsdjeg/vim-fetch'          " support opening line and column numbers (e.g. foo.bar:13)

" LSP stuff
Plug 'neovim/nvim-lspconfig'

" language support
Plug 'MaxMEllon/vim-jsx-pretty'
Plug 'cespare/vim-toml'
Plug 'elixir-editors/vim-elixir'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'fladson/vim-kitty'
Plug 'godlygeek/tabular', { 'for': 'markdown' }
Plug 'google/vim-jsonnet'
Plug 'jparise/vim-graphql'
Plug 'leafgarland/typescript-vim'
Plug 'neovimhaskell/haskell-vim'
Plug 'pangloss/vim-javascript'
Plug 'plasticboy/vim-markdown'
Plug 'rust-lang/rust.vim'
Plug 'tpope/vim-ragtag'

" fzf
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

" trying out
Plug 'mbbill/undotree'
Plug 'preservim/tagbar'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-projectionist'

" keeping this around until I find a better solution for typescript
Plug 'dense-analysis/ale', { 'for': ['javascript', 'typescript', 'typescriptreact'] }

call plug#end()
" }}}

" COLOR SCHEME {{{
set termguicolors
source $VIM_FILES/theme.vim " this file is created by running `set-theme`
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

" yank/paste to/from system clipboard
" (recursive mappings are intentionally used to preserve the benefits of
" preserving cursor position provided by vim-yoink)
nmap <Leader>d "+d
xmap <Leader>d "+d
nmap <Leader>y "+y
xmap <Leader>y "+y
nmap <Leader>p "+p
xmap <Leader>p "+p

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

" maximize the pane
nnoremap <C-w>m <C-w><bar><C-w>_

" copy the file with another name
nnoremap <Leader>cc :saveas %:h<C-z>

" create a new file in the same directory
nnoremap <Leader>cn :e %:h<C-z>
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
" vim-mucomplete {{{
let g:mucomplete#chains = {}
let g:mucomplete#can_complete = {}
" }}}

" vim-qf {{{
let g:qf_mapping_ack_style = 1

nmap <Leader>qf <Plug>(qf_qf_toggle)
nmap <Leader>ql <Plug>(qf_loc_toggle)
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
nmap gs <Plug>(GrepperOperator)
xmap gs <Plug>(GrepperOperator)
" }}}

" neomake {{{
call neomake#configure#automake('rw')
let g:neomake_cursormoved_delay = 10
let g:neomake_virtualtext_prefix = ' ❯❯ '

let g:neomake_error_sign = {
            \ 'text': 'XX',
            \ 'texthl': 'NeomakeErrorSign',
            \ }
let g:neomake_warning_sign = {
            \ 'text': '!!',
            \ 'texthl': 'NeomakeWarningSign',
            \ }
let g:neomake_message_sign = {
            \ 'text': '>>',
            \ 'texthl': 'NeomakeMessageSign',
            \ }
let g:neomake_info_sign = {
            \ 'text': 'ii',
            \ 'texthl': 'NeomakeInfoSign'
            \ }
let g:neomake_highlight_columns = 0


nnoremap <silent> <Leader>m :Neomake!<CR>
nnoremap <silent> <C-k> :NeomakePrevLoclist<CR>
nnoremap <silent> <C-j> :NeomakeNextLoclist<CR>
" }}}

" targets.vim {{{
let g:targets_seekRanges = 'cc cr cb cB lc ac Ac'      " ranges on the cursor
let g:targets_seekRanges .= ' lr'                      " range around the cursor, fully contained on the same line
let g:targets_seekRanges .= ' rr'                      " range ahead of the cursor, fully contained on the same line
let g:targets_seekRanges .= ' lb ar ab lB Ar aB Ab AB' " ranges around the cursor, multiline
let g:targets_seekRanges .= ' ll'                      " ranges behind the cursor, fully contained on the same line
" }}}

" vim-go {{{
let g:go_fmt_command = 'goimports'
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
let g:fzf_preview_window = [] " disable the preview window

nnoremap <silent> <Leader>f :Files<CR>
nnoremap <silent> <Leader>F :GFiles<CR>
nnoremap <silent> <Leader>l :Buffers<CR>
nnoremap <silent> <Leader>; :BLines<CR>
nnoremap <silent> <Leader>: :Lines<CR>
nnoremap <silent> <Leader>k :BTags<CR>
" nnoremap <silent> <Leader>m :Marks<CR>
nnoremap <silent> <bar> :Rg<CR>

augroup FZF
    autocmd!
    autocmd User FzfStatusLine setlocal statusline=%#StatusLine#\ »\ fzf
augroup END
" }}}

" vim-signify {{{
let g:signify_vcs_list = ['git']
let g:signify_priority = 9 " allow neomake to have priority
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

nnoremap <silent> <Leader>K :TagbarToggle<CR>
" }}}

" {{{ undotree
let g:undotree_SetFocusWhenToggle = 1
let g:undotree_WindowLayout = 3
let g:undotree_SplitWidth = 50

nnoremap <silent> <Leader>u :UndotreeToggle<CR>
" }}}

" {{{ vim-obsession
" save a session using the current cwd and git branch name as identifiers
function! s:SaveSession() abort
    let session_id = substitute(getcwd(), '/', '_', 'g')
    let branch = gina#component#repo#branch()
    if branch != ''
        let session_id = session_id . '@' . branch
    endif

    let sessions_dir = $VIM_FILES . '/sessions'
    let _ = system('mkdir -p ' . sessions_dir)
    execute 'Obsession ' . sessions_dir . '/' . session_id . '.vim'
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

" ale {{{
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_text_changed = 'never'
let g:ale_set_highlights = 1
let g:ale_sign_error = '!!'
let g:ale_sign_warning = '!!'

let g:ale_linters = {
            \ 'javascript': ['tsserver', 'eslint', 'prettier'],
            \ 'typescript': ['tsserver', 'eslint', 'prettier'],
            \ 'typescriptreact': ['tsserver', 'eslint', 'prettier'],
            \ }
let g:ale_fixers = {
            \ 'javascript': ['prettier'],
            \ 'typescript': ['prettier'],
            \ 'typescriptreact': ['prettier'],
            \ }
let g:ale_fix_on_save = 1

augroup ALE
    autocmd!

    autocmd FileType javascript,typescript,typescriptreact nmap <buffer> <C-k> <Plug>(ale_previous)
    autocmd FileType javascript,typescript,typescriptreact nmap <buffer> <C-j> <Plug>(ale_next)
    autocmd FileType javascript,typescript,typescriptreact nmap <buffer> <Leader>d <Plug>(ale_go_to_definition)
    autocmd FileType javascript,typescript,typescriptreact nmap <buffer> <C-]> <Plug>(ale_go_to_definition)
    autocmd FileType javascript,typescript,typescriptreact nmap <buffer> <Leader>h <Plug>(ale_hover)
    autocmd FileType javascript,typescript,typescriptreact setlocal omnifunc=ale#completion#OmniFunc
augroup END
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
    autocmd FileType go setlocal noexpandtab shiftwidth=8
    autocmd FileType go setlocal textwidth=100

    autocmd FileType go nnoremap <silent> <buffer> <Leader>h :GoInfo<CR>
    autocmd FileType go nnoremap <silent> <buffer> <Leader>gc :GoCallers<CR>
    autocmd FileType go nnoremap <silent> <buffer> <Leader>gr :GoReferrers<CR>

    autocmd FileType go iabbrev <buffer> ife; if err != nil {<CR>return err<ESC>ja
    autocmd FileType go iabbrev <buffer> ifne; if err != nil {<CR>return nil, err<ESC>ja
    autocmd FileType go iabbrev <buffer> iffe; if err :=; err != nil {<CR>return err<ESC>k0f;i
    autocmd FileType go iabbrev <buffer> iffne; if err :=; err != nil {<CR>return nil, err<ESC>k0f;i
    autocmd FileType go iabbrev <buffer> dbg; b, _ := json.MarshalIndent(Z, "", "\t")<CR>fmt.Printf("[DEBUGGING]: %+v\n", b)<ESC>k0fZcw

    let g:mucomplete#chains.go = ['omni']
    let g:mucomplete#can_complete.go = {
                \    'omni': { t -> strlen(&l:omnifunc) > 0 }
                \    }
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
    autocmd Filetype javascript,typescript,typescriptreact setlocal shiftwidth=2 softtabstop=2
augroup END

augroup PRS
    autocmd!
    autocmd BufEnter */PULLREQ_EDITMSG setlocal ft=markdown
augroup END

augroup YAML
    autocmd!
    autocmd Filetype yaml setlocal shiftwidth=2 softtabstop=2
augroup END
" }}}

runtime local.vim
