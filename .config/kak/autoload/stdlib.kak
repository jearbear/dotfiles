# Ensure that we still load the standard set of plugins
nop %sh{
    if [ ! -e "$kak_config/autoload/stdlib" ]; then
        mkdir -p "$kak_config/autoload"
        ln -s "$kak_runtime/autoload" "$kak_config/autoload/stdlib"
        # We need to restart the session for ^ to take effect, so just
        # kill the session with the assumption that I'll restart it.
        printf "kill!" | kak -p ${kak_session}
    fi
}
