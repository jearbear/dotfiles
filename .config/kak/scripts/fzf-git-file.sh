file="$(git status --short |
    fzf --accept-nth 2 \
        --history /tmp/kak-fzf-git-file \
        --preview 'git diff --color=always {2} | delta' \
        --preview-window up:60%)"
if [ "$file" ]; then
    printf "evaluate-commands -client $kak_client 'edit $file'" | kak -p "$kak_session"
fi
