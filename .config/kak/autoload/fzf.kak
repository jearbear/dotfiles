define-command fzf-file %{
    nop %sh{
        kitten @ launch --type overlay --cwd current --copy-env -- dash -c '
            file="$(fzf)"
            if [ "$file" ]; then
                printf "eval -client $kak_client edit $file" | kak -p "$kak_session"
            fi
        '
    }
}
