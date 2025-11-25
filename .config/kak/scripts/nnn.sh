file="$(nnn -CRorA -p - $kak_buffile)"
if [ "$file" ]; then
    printf "evaluate-commands -client $kak_client 'edit $file'" | kak -p "$kak_session"
fi
