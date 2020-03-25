export KEYTIMEOUT=1
export EDITOR='nvim'
export PAGER='less'
export GPG_TTY=$(tty)

export FZF_DEFAULT_COMMAND='(git ls-files || fd -t file) 2> /dev/null'
export FZF_DEFAULT_OPTS='--color=fg:#2a2b33,bg:#f8f8f8,hl:#a00095,fg+:#2a2b33,bg+:#f8f8f8,hl+:#950095,info:#bbbbbb,prompt:#bbbbbb,pointer:#bbbbbb,marker:#bbbbbb,spinner:#bbbbbb,header:#bbbbbb'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export GOPASS_EXTERNAL_PWGEN="xkcd-pass"

export PATH="$HOME/.bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.npm-packages/bin:$PATH"

export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"

# system-specific
[ -f ~/.zshenv.local ] && source ~/.zshenv.local
