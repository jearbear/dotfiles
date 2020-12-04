export KEYTIMEOUT=1
export EDITOR='nvim'
export PAGER='less'
export GPG_TTY=$(tty)

export FZF_DEFAULT_COMMAND='fd -t file'
export FZF_DEFAULT_OPTS='--color=16'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export GOPASS_EXTERNAL_PWGEN="xkcd-pass"

export PATH="$HOME/.bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.npm-packages/bin:$PATH"

export BAT_THEME='base16' # TODO: Update this to 'base16-256' when bat is updated

# system-specific
[ -f ~/.zshenv.local ] && source ~/.zshenv.local
