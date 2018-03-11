# vim readline keybindings
bindkey -v
bindkey '^o' vi-cmd-mode

# preserve some emacs bindings that don't conflict
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line
bindkey '^b' backward-word
bindkey '^f' forward-word
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word
bindkey '^k' kill-line
bindkey '^u' kill-whole-line
bindkey "^p" history-beginning-search-backward
bindkey "^n" history-beginning-search-forward

# preserve the ability to shift-tab complete
bindkey '^[[Z' reverse-menu-complete

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

# vim/insert mode info
function zle-line-init zle-keymap-select {
    INSERT_MODE=''
    VIM_MODE='%F{magenta}'
    CMD_MODE="${${KEYMAP/vicmd/${VIM_MODE}}/(main|viins)/${INSERT_MODE}}"
    zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

# prompt
PROMPT='%1/ %F{yellow}●%f ${CMD_MODE}'
RPROMPT='%F{yellow}${vcs_info_msg_0_}%f'

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

# source local configs
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
