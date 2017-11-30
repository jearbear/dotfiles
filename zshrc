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

# readline bindings
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
bindkey '^o' edit-command-line

# prompt
PROMPT='%1/%F{yellow} » %f'

# aliases
alias sizes='du -d 1 -h . | sort -rh'
alias first='head -n 1'
alias reload='source ~/.zshrc && source ~/.zshenv'

alias vi='nvim'
alias vim='nvim'
alias t='tmux new-session -A -s main'
alias pn='ping www.google.com -c 1'

alias s='sudo'

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# gopass
source <(gopass completion zsh)

# system-specific
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
