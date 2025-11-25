file="$(fzf --preview 'bat --force-colorization {}' --preview-window up:60% --history /tmp/kak-fzf-file)"
if [ "$file" ]; then
    printf "evaluate-commands -client $kak_client 'edit $file'" | kak -p "$kak_session"
fi
