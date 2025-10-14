# Catppuccin Mocha

evaluate-commands %sh{
    rosewater='rgb:f5e0dc'
    flamingo='rgb:f2cdcd'
    pink='rgb:f5c2e7'
    mauve='rgb:cba6f7'
    red='rgb:f38ba8'
    maroon='rgb:eba0ac'
    peach='rgb:fab387'
    yellow='rgb:f9e2af'
    green='rgb:a6e3a1'
    teal='rgb:94e2d5'
    sky='rgb:89dceb'
    sapphire='rgb:74c7ec'
    blue='rgb:89b4fa'
    lavender='rgb:b4befe'
    text='rgb:cdd6f4'
    subtext1='rgb:bac2de'
    subtext0='rgb:a6adc8'
    overlay2='rgb:9399b2'
    overlay1='rgb:7f849c'
    overlay0='rgb:6c7086'
    surface2='rgb:585b70'
    surface1='rgb:45475a'
    surface0='rgb:313244'
    base='rgb:1e1e2e'
    mantle='rgb:181825'
    crust='rgb:11111b'

    echo "
        set-face global title  ${text}+b
        set-face global header ${subtext0}+b
        set-face global bold   ${maroon}+b
        set-face global italic ${maroon}+i
        set-face global mono   ${green}
        set-face global block  ${sapphire}
        set-face global link   ${blue}
        set-face global bullet ${peach}
        set-face global list   ${peach}

        set-face global Default            ${text},${base}
        set-face global PrimarySelection   ${text},${surface2}
        set-face global SecondarySelection ${text},${surface2}
        set-face global PrimaryCursor      ${crust},${rosewater}
        set-face global SecondaryCursor    ${text},${overlay0}
        set-face global PrimaryCursorEol   ${surface2},${lavender}
        set-face global SecondaryCursorEol ${surface2},${overlay1}
        set-face global LineNumbers        ${overlay1},${base}
        set-face global LineNumberCursor   ${rosewater},${surface2}+b
        set-face global LineNumbersWrapped ${rosewater},${surface2}
        set-face global MenuForeground     ${text},${surface1}+b
        set-face global MenuBackground     ${text},${surface0}
        set-face global MenuInfo           ${crust},${teal}
        set-face global Information        ${crust},${teal}
        set-face global Error              ${crust},${red}
        set-face global StatusLine         ${text},${mantle}
        set-face global StatusLineMode     ${crust},${yellow}
        set-face global StatusLineInfo     ${crust},${teal}
        set-face global StatusLineValue    ${crust},${yellow}
        set-face global StatusCursor       ${crust},${rosewater}
        set-face global Prompt             ${teal},${base}+b
        set-face global MatchingChar       ${maroon},${base}
        set-face global Whitespace         ${overlay1},${base}+f
        set-face global WrapMarker         Whitespace
        set-face global BufferPadding      ${base},${base}

        set-face global value         ${peach}
        set-face global type          ${blue}
        set-face global variable      ${text}
        set-face global module        ${maroon}
        set-face global function      ${blue}
        set-face global string        ${green}
        set-face global keyword       ${mauve}
        set-face global operator      ${sky}
        set-face global attribute     ${green}
        set-face global comment       ${overlay0}
        set-face global documentation comment
        set-face global meta          ${yellow}
        set-face global builtin       ${red}
    "
}
