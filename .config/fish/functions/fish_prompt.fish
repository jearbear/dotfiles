function fish_prompt
    set_color brblack
    echo -n (prompt_pwd)
    set_color purple
    echo -n ' ∷ '
    set_color normal
end
