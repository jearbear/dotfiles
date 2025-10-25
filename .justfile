# vim: set ft=just :

help:
    just --list --unsorted

git := "git --git-dir ~/.dotfiles --work-tree ~"

status:
    {{git}} status

diff:
    {{git}} diff

add +paths:
    {{git}} add --force {{paths}}

save:
    {{git}} save

pull:
    {{git}} pull --rebase

ls:
    {{git}} ls-files | tree --fromfile -C | less

git +args:
    {{git}} {{args}}

alias s := status
alias a := add
alias g := git
alias d := diff
