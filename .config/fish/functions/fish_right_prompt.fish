function fish_right_prompt
    jj root &> /dev/null
    if test $status -ne 0
        return
    end

    set_color yellow
    echo -n '// '
    echo -en (jj log --ignore-working-copy --no-graph --color never -r @ -T '
        separate(
            " ",
            blue(bookmarks.join(", ")),
            if(empty, green(change_id.shortest()), blue(change_id.shortest())),
            if(
                description,
                brblack(surround(
                    "\"",
                    "\"",
                    description.first_line().substr(0, 20) ++ "…"
                )),
                ""
            ),
        )
        ++
        brblack(" / ")
        ++
        parents.map(|p| separate(
            " ",
            blue(p.bookmarks().join(", ")),
            if(p.empty(), green(p.change_id().shortest()), blue(p.change_id().shortest())),
            if(
                p.description(),
                brblack(surround(
                    "\"",
                    "\"",
                    p.description().first_line().substr(0, 20) ++ "…"
                )),
                ""
            ),
        ))
    ')
end
