define-command fzf %{
    nop %sh{
        printf "$client_env_PWD" >&2
        fd --type file --base-directory "/home/jerry/.config" | kitten @ launch --type overlay -- fzf
    }
}
