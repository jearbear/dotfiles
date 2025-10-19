declare-user-mode surround
declare-user-mode surround-add
declare-user-mode surround-delete


define-command surround-add -params 2 %{
    execute-keys _
    evaluate-commands -draft -save-regs '"' %{
        set-register '"' %arg{1}
        execute-keys -draft P
        set-register '"' %arg{2}
        execute-keys -draft p
    }
}

define-command -hidden surround-delete-key -params 1 %{
    execute-keys -draft "<a-a>%arg{1}i<del><esc>a<backspace><esc>"
}

define-command surround-delete %{
    on-key %{
        surround-delete-key %val{key}
    }
}

define-command -hidden surround-replace-sub -params 1 %{
    on-key %{
        evaluate-commands -no-hooks -draft %{
            execute-keys "<a-a>%arg{1}"
            enter-user-mode surround-add
            execute-keys %val{key}
        }
        surround-delete-key %arg{1}
   }
}

define-command surround-replace %{
    on-key %{
        surround-replace-sub %val{key}
    }
}


map global user s ':enter-user-mode surround<ret>' -docstring "enter surround mode"

map global surround a ':enter-user-mode surround-add<ret>' -docstring "add surround"

map global surround-add b   ':surround-add ( )<ret>'         -docstring 'surround with parenthesis'
map global surround-add (   ':surround-add ( )<ret>'         -docstring 'surround with parenthesis'
map global surround-add )   ':surround-add ( )<ret>'         -docstring 'surround with parenthesis'
map global surround-add [   ':surround-add [ ]<ret>'         -docstring 'surround with brackets'
map global surround-add ]   ':surround-add [ ]<ret>'         -docstring 'surround with brackets'
map global surround-add {   ':surround-add { }<ret>'         -docstring 'surround with curly brackets'
map global surround-add }   ':surround-add { }<ret>'         -docstring 'surround with curly brackets'
map global surround-add <   ':surround-add < ><ret>'         -docstring 'surround with angle brackets'
map global surround-add >   ':surround-add < ><ret>'         -docstring 'surround with angle brackets'
map global surround-add "'" ":surround-add ""'"" ""'""<ret>" -docstring 'surround with quotes'
map global surround-add '"' ":surround-add '""' '""'<ret>"   -docstring 'surround with double quotes'
map global surround-add *   ':surround-add * *<ret>'         -docstring 'surround with asteriks'
map global surround-add _   ':surround-add _ _<ret>'         -docstring 'surround with undescores'

map global surround d ':surround-delete<ret>' -docstring "delete surround"

map global surround c ':surround-replace<ret>' -docstring "replace surround"
