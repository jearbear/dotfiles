define-command git-blame-line %{
    evaluate-commands %{
        set-register a %sh{
            git log -s -1 -L "$kak_cursor_line,$kak_cursor_line:$kak_buffile"
        }
        info %reg{a}
    }
}

define-command git-blame-line-open-pr %{
    nop %sh{
        pr_url="$(git remote get-url origin | sed 's/:/\//; s/git@/https:\/\//; s/\.git/\/pull\//')"
        pr_number="$(git log -s -1 -L "$kak_cursor_line,$kak_cursor_line:$kak_buffile" | rg '\(#(\d+)\)' --only-matching --replace '$1')"
        open "$pr_url/$pr_number"
    }
}

define-command git-open-line %{
    nop %sh{
        file_path="$(git ls-files $kak_buffile)"
        commit_sha="$(git rev-parse HEAD)"
        tree_url="$(git remote get-url origin | sed 's/:/\//; s/git@/https:\/\//; s/\.git/\/blob/')"
        open "$tree_url/$commit_sha/$file_path#L$kak_cursor_line"
    }
}
