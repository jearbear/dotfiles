result="$(rg --color=always --line-number --no-heading --smart-case --trim "" |
    fzf --ansi \
        --delimiter : \
        --nth 3 \
        --accept-nth 1,2 \
        --history /tmp/kak-fzf-rg \
        --preview 'bat --color=always {1} --highlight-line {2}' \
        --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' |
    awk -F ':' '{print $1, $2}')"

if [ "$result" ]; then
    printf "evaluate-commands -client $kak_client 'edit $result'" | kak -p "$kak_session"
fi
