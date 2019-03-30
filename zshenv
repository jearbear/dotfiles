export KEYTIMEOUT=1
export EDITOR='nvim'
export PAGER='less'
export GPG_TTY=$(tty)

export FZF_DEFAULT_COMMAND='(git ls-files || fd -t file) 2> /dev/null'
export FZF_DEFAULT_OPTS='--color="fg:#d5c4a1,bg:#32302f,hl:#fabd2f,fg+:#ebdbb2,info:#8ec07c,prompt:#fabd2f,pointer:#fabd2f,marker:#d79921,spinner:#8ec07c,header:#fe8019,hl+:#fabd2f"'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export GOPASS_EXTERNAL_PWGEN="xkcd-pass"

export RUSTC_WRAPPER='sccache'

export PATH="$HOME/.bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.cabal/bin:$PATH"
export PATH="$HOME/.npm-packages/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"

# system-specific
[ -f ~/.zshenv.local ] && source ~/.zshenv.local
