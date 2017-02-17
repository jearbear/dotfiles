bindkey -e

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

# useful aliases
alias -g ls='ls --color=auto'
alias calc='python -ic "from math import *; import cmath"'
alias vim='nvim'
alias com='commander'
alias power='glances --hide-kernel-threads --process-short-name -1 -2 -4'
alias recon='systemctl restart connman'
alias feh='feh -.'

alias dots='git --git-dir=$HOME/.dots/ --work-tree=$HOME'

# bindings
bindkey '^[[Z' reverse-menu-complete
bindkey '^?' vi-backward-delete-char
bindkey '^W' vi-backward-kill-word
bindkey '^R' history-incremental-search-backward
bindkey "^P" history-beginning-search-backward
bindkey "^N" history-beginning-search-forward
bindkey "^B" vi-backward-word
bindkey "^F" vi-forward-word

# edit command in $EDITOR
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^xe' edit-command-line

# prompt
PROMPT='%1/%F{yellow} •• %f'

# autojump
source /etc/profile.d/autojump.zsh
