define-command -hidden kitty-script-launch -params 1 %{
    nop %sh{
        # Ensure that the following variables are available in the script
        # $kak_buffile
        # $kak_client
        # $kak_session

        kitten @ launch --type overlay --cwd current --copy-env -- dash "$kak_config/scripts/$1.sh"
    }
}
