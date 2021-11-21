# NOTE: I keep forgetting this, but this file is always sourced even when the
# shell is invoked to execute a single command, so keepe it fast! Otherwise,
# you're going to experience slowness in situations where subshells are used
# (e.g. vim executing shell commands).

export KEYTIMEOUT=1
export EDITOR='nvim'
export PAGER='less'
export GPG_TTY=$(tty)

export GOPATH=$HOME/go

export FZF_DEFAULT_COMMAND='fd --type file'
export FZF_DEFAULT_OPTS='--color=16'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export MANPAGER='nvim +Man!'

typeset -U PATH path # deduplicate PATH
path=(
    "$HOME/.bin"
    "$HOME/.cargo/bin" # Rust
    "$HOME/go/bin" # Golang
    "/usr/local/bin" # Mac stuff
    "$path[@]"
)
export PATH

export BAT_THEME='base16-256'

# system-specific
[ -f ~/.zshenv.local ] && source ~/.zshenv.local
