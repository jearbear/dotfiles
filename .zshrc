# emacs readline keybindings
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
HISTSIZE=1000000000
SAVEHIST=1000000000
HISTORY_IGNORE="(ls|cd|pwd|exit|cd)*"

setopt EXTENDED_HISTORY      # write the history file in the ':start:elapsed;command' format.
setopt INC_APPEND_HISTORY    # write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY         # share history between all sessions.
setopt HIST_IGNORE_DUPS      # do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS  # delete an old recorded event if a new event is a duplicate.
setopt HIST_IGNORE_SPACE     # do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS     # do not write a duplicate event to the history file.
setopt HIST_VERIFY           # do not execute immediately upon history expansion.
setopt APPEND_HISTORY        # append to history file (default)
setopt HIST_NO_STORE         # don't store history commands
setopt HIST_REDUCE_BLANKS    # remove superfluous blanks from each command line being added to the history.

# background jobs
setopt NO_HUP NO_CHECK_JOBS

# globbing settings
setopt extendedglob no_CASE_GLOB

# misc settings
setopt notify
unsetopt beep

# completion for sd
fpath=(~/.completions $fpath)

# completion
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}'
setopt completeinword
autoload -Uz compinit promptinit
# setup completions for packages installed via homebrew (must be done before
# compinit)
FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
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
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr ' [!]'
zstyle ':vcs_info:*' unstagedstr ' [?]'
precmd() {
    vcs_info
}
zstyle ':vcs_info:git*' formats "%F{magenta}// %F{white}%b%F{green}%c%F{red}%u"
setopt prompt_subst

# prompt
PROMPT='%1/ %F{magenta}%(1j.[%j] .)//%f '
RPROMPT='${vcs_info_msg_0_}%f'

# if a virtualenv is activated by direnv, we need to maually update the prompt
show_virtual_env() {
  if [[ -n "$VIRTUAL_ENV" && -n "$DIRENV_DIR" ]]; then
    echo "[$(basename $VIRTUAL_ENV)] "
  fi
}
PROMPT='$(show_virtual_env)'$PROMPT


# aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ls='ls -GF' # enable color and sigils depending on filetype
alias n='nnn -CReorA'
alias pn='ping www.google.com -c 1'
alias reload='source ~/.zshrc && source ~/.zshenv'
alias rgm='rg --multiline --multiline-dotall'
alias rgo='rg --no-heading --no-filename --no-line-number --only-matching'
alias j='just'
alias g='git'
alias we='watchexec'
alias d='date -r'
alias np='pnpm'

alias cdg='cd ~/Projects/giga'
alias cds='cd ~/Projects/sugo'

alias dots='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
compdef dots='git' # enable completion for ^
alias sdots='git --git-dir=$HOME/.dotfiles.secret/ --work-tree=$HOME'
compdef sdots='git' # enable completion for ^

alias vi='nvim'
alias vim='nvim'
alias watch='watch --color --interval 5'

alias kssh='kitty +kitten ssh'

# determine if the CWD is within a git repo
__is_in_git_repo() {
    git rev-parse HEAD > /dev/null 2>&1
}


# fzf
[ -r ~/.fzf.zsh ] && . ~/.fzf.zsh

# disable a conflicting mapping to allow for fzf + git integrations
bindkey -r '^G'

# select a git commit from the branch via FZF and dump it into the prompt
__git-pick-branch-commit() {
    __is_in_git_repo || return
    LBUFFER="${LBUFFER}$(git pick branch-commit) "
    zle reset-prompt
}
zle -N __git-pick-branch-commit
bindkey '^G^P' __git-pick-branch-commit

# select a git commit from the log via FZF and dump it into the prompt
__git-pick-commit() {
    __is_in_git_repo || return
    LBUFFER="${LBUFFER}$(git pick commit) "
    zle reset-prompt
}
zle -N __git-pick-commit
bindkey '^G^L' __git-pick-commit

# select a git branch via FZF and dump it into the prompt
__git-pick-branch() {
    __is_in_git_repo || return
    LBUFFER="${LBUFFER}$(git pick branch) "
    zle reset-prompt
}
zle -N __git-pick-branch
bindkey '^G^B' __git-pick-branch

# select a git unstaged file via FZF and dump it into the prompt
__git-pick-files() {
    __is_in_git_repo || return
    LBUFFER="${LBUFFER}$(git pick files)"
    zle reset-prompt
}
zle -N __git-pick-files
bindkey '^G^F' __git-pick-files

# enable direnv
eval "$(direnv hook zsh)"

# enable rtx
eval "$(rtx activate zsh)"

# enable side-by-side mode for git diff output if the terminal is wide enough
__preexec_function () {
    local columns=$(tput cols)
    if [ $columns -ge 200 ]; then
        export GIT_PAGER="delta --side-by-side"
    else
        export GIT_PAGER="delta"
    fi
}
typeset -ag preexec_functions;
preexec_functions=( __preexec_function ${preexec_functions[@]} )


# source local configs
[ -r ~/.zshrc.local ] && . ~/.zshrc.local
