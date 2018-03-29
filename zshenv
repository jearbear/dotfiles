export KEYTIMEOUT=1
export EDITOR='nvim'
export PAGER=less
export BUILDDIR=/tmp/makepkg makepkg
export MAKEFLAGS='-j${nproc}'
export PKGEXT='.pkg.tar'
export GPG_TTY=`tty`

export FZF_DEFAULT_COMMAND='fd -t file'
export FZF_DEFAULT_OPTS='--color="fg:#d5c4a1,bg:#32302f,hl:#fabd2f,fg+:#ebdbb2,info:#8ec07c,prompt:#fabd2f,pointer:#fabd2f,marker:#d79921,spinner:#8ec07c,header:#fe8019,hl+:#fabd2f"'
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND

export PATH="$HOME/.bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.npm-packages/bin:$PATH"

# system-specific
[ -f ~/.zshenv.local ] && source ~/.zshenv.local
