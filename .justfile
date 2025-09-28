# vim: set ft=just :

help:
    just --list --unsorted

git := "git --git-dir ~/.dotfiles --work-tree ~"

# Show git status of dotfiles
status:
    {{git}} status

# Add path to dotfiles
add +paths:
    {{git}} add --force {{paths}}

# Push changes to Github
save:
    {{git}} save

# Execute arbitrary git commands against the dotfiles repo
git +args:
    {{git}} {{args}}

alias s := status
alias a := add
alias g := git
