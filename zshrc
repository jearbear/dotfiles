# vim readline keybindings
bindkey -e

# bash-like navigation
autoload -U select-word-style
select-word-style bash

# navigate command history with prefix
bindkey "^p" history-beginning-search-backward
bindkey "^n" history-beginning-search-forward

# preserve the ability to shift-tab complete
bindkey '^[[Z' reverse-menu-complete

# more emacs-like bindings
bindkey '^H' backward-kill-word

# history
HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=100000
setopt HIST_IGNORE_DUPS appendhistory

# background jobs
setopt NO_HUP NO_CHECK_JOBS

# globbing settings
setopt extendedglob no_CASE_GLOB

# misc settings
setopt notify
unsetopt beep

# completion
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}'
setopt completealiases completeinword
autoload -Uz compinit promptinit
compinit

# colors
autoload -U colors && colors

# edit command in $EDITOR
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^v' edit-command-line

# version control info
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
precmd() {
    vcs_info
}
zstyle ':vcs_info:git*' formats "- %b -"
setopt prompt_subst

# prompt
PROMPT='%1/ %F{yellow}-%f '
RPROMPT='%F{yellow}${vcs_info_msg_0_}%f'

# aliases
alias sizes='du -d 1 -h . | sort -rh'
alias reload='source ~/.zshrc && source ~/.zshenv'

alias n='DISABLE_FILE_OPEN_ON_NAV=1 nnn -l -c 6'

alias vi='nvim'
alias vim='nvim'
alias t='tmux new-session -A -s main'
alias pn='ping www.google.com -c 1'

alias s='sudo'

alias pass='gopass -c $(gopass ls -f | fzf)'
alias pgen='gopass generate --xkcdsep "" -e'

alias ob='ocp-browser --no-stdlib --open Core'

# fzf
[ -r ~/.fzf.zsh ] && . ~/.fzf.zsh

# opam
[ -r ~/.opam/opam-init/init.zsh ] && . ~/.opam/opam-init/init.zsh

# source local configs
[ -r ~/.zshrc.local ] && . ~/.zshrc.local
