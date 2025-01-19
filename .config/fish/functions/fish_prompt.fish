function fish_prompt
    set_color brblack
    echo -n (prompt_pwd)
    set_color yellow
    echo -n ' // '
    set_color normal
end
