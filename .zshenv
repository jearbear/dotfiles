# NOTE: I keep forgetting this, but this file is always sourced even when the
# shell is invoked to execute a single command, so keep it fast! Otherwise,
# you're going to experience slowness in situations where subshells are used
# (e.g. vim executing shell commands).

export KEYTIMEOUT=1
export EDITOR='nvim'
export VISUAL='nvim'
export PAGER='less'
export GPG_TTY=$(tty)

export GOPATH=$HOME/go

export FZF_DEFAULT_COMMAND='fd --type file'
export FZF_DEFAULT_OPTS="--color=16,fg:white:dim,bg:-1,preview-fg:-1,preview-bg:-1,hl:yellow:regular,fg+:yellow:regular:bold,bg+:-1,gutter:-1,hl+:yellow:regular:bold,query:white,info:magenta,border:magenta:dim,prompt:magenta,marker:cyan:bold,spinner:magenta,disabled:gray,header:gray,pointer:red --bind ctrl-n:next-history --bind ctrl-p:prev-history --bind ctrl-/:toggle-all --bind ctrl-delete:backward-kill-word"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# FZF used to be an ncurses program so had this as a non-zero value to support
# windows? In practice this just makes closing it feel sluggish, especially in
# Vim, so we just disable it.
export ESCDELAY=0

export MANPAGER='nvim +Man!'

typeset -U PATH path # deduplicate PATH
path=(
    "$HOME/.bin"
    "$HOME/.cargo/bin" # Rust
    "$HOME/go/bin" # Golang
    "$path[@]"
)
export PATH

# completion for sd
fpath=(~/src/sd $fpath)

export BAT_THEME='base16'

# enable history in iex
export ERL_AFLAGS="-kernel shell_history enabled"

# system-specific
[ -f ~/.zshenv.local ] && source ~/.zshenv.local
