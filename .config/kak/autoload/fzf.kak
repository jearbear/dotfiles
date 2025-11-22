define-command fzf-file %{
    nop %sh{
        kitten @ launch --type overlay --cwd current --copy-env --wait-for-child-to-exit -- dash -c '
            file="$(fzf --preview '\''bat --force-colorization {}'\'' --preview-window up:40)"
            if [ "$file" ]; then
                printf "edit $file" > "$kak_command_fifo"
            fi
        '
    }
}

define-command fzf-git-file %{
    nop %sh{
        kitten @ launch --type overlay --cwd current --copy-env --wait-for-child-to-exit -- dash -c '
            file="$(git status --short | fzf --accept-nth 2 --preview '\''git diff --color=always {2} | delta'\'' --preview-window up:40)"
            if [ "$file" ]; then
                printf "edit $file" > "$kak_command_fifo"
            fi
        '
    }
}
