export KEYTIMEOUT=1
export EDITOR='nvim'
export PAGER='less'
export GPG_TTY=$(tty)

export FZF_DEFAULT_COMMAND='fd -t file'
export FZF_DEFAULT_OPTS='--color=16'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export MANPAGER='nvim +Man!'

typeset -U PATH path # deduplicate PATH
path=(
    "$HOME/.bin"
    "$HOME/.local/bin"
    "$HOME/.cargo/bin"
    "$HOME/.npm-packages/bin"
    "$path[@]"
)
export PATH

export BAT_THEME='base16-256'

# system-specific
[ -f ~/.zshenv.local ] && source ~/.zshenv.local
