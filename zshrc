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
zstyle ':vcs_info:git*' formats "%F{magenta}// %F{white}%b"
setopt prompt_subst

# prompt
PROMPT='%1/ %F{magenta}%(1j.[%j] .)//%f '
RPROMPT='${vcs_info_msg_0_}%f'

# base16 shell
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && [ -s "$BASE16_SHELL/profile_helper.sh" ] && eval "$("$BASE16_SHELL/profile_helper.sh")"

# aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ls='ls -GF' # enable color and sigils depending on filetype
alias n='nnn -CReor'
alias pn='ping www.google.com -c 1'
alias reload='source ~/.zshrc && source ~/.zshenv'
alias rgm='rg --multiline --multiline-dotall'
alias rgo='rg --no-heading --no-filename --no-line-number --only-matching'
alias s='sudo'
alias t='TERM=xterm-256color tmux new-session -A -s main'
alias vi='nvim'
alias vim='nvim'
alias watch='watch --color --interval 5'

# quickly load the relevant vim session
alias vs='__vim_with_session'
function __vim_with_session() {
    if [ -d '.git' ]; then
        [ ! -d ".git/sessions" ] && mkdir ".git/sessions"
        touch ".git/sessions/$(git branch-name).vim"
        nvim -S ".git/sessions/$(git branch-name).vim"
    elif [ -f 'Session.vim' ]; then
        nvim -S 'Session.vim'
    else
        nvim
    fi;
}

# directory shortcuts
hash -d dots=$HOME/.dotfiles

# fzf
[ -r ~/.fzf.zsh ] && . ~/.fzf.zsh

# fzf + git integrations
bindkey -r '^G'

# determine if the CWD is within a git repo
__is_in_git_repo() {
    git rev-parse HEAD > /dev/null 2>&1
}

# select a git commit via FZF and dump it into the prompt
__git-pick-commit() {
    __is_in_git_repo || return
    LBUFFER="${LBUFFER}$(git pick-commit) "
    zle reset-prompt
}
zle -N __git-pick-commit
bindkey '^G^P' __git-pick-commit

# select a git branch via FZF and dump it into the prompt
__git-pick-branch() {
    __is_in_git_repo || return
    LBUFFER="${LBUFFER}$(git pick-branch) "
    zle reset-prompt
}
zle -N __git-pick-branch
bindkey '^G^B' __git-pick-branch

# select a git unstaged file via FZF and dump it into the prompt
__git-pick-unstaged-files() {
__is_in_git_repo || return
LBUFFER="${LBUFFER}$(git pick-unstaged-files) "
zle reset-prompt
}
zle -N __git-pick-unstaged-files
bindkey '^G^U' __git-pick-unstaged-files

# source local configs
[ -r ~/.zshrc.local ] && . ~/.zshrc.local
