declare-option str system_yank_command "%sh{ test $(uname) = Darwin && echo pbcopy || echo wl-copy }"
declare-option str system_paste_command "%sh{ test $(uname) = Darwin && echo pbpaste || echo wl-paste }"


define-command execute-keys-with-system-clipboard -hidden -params 1 %{
    evaluate-commands -save-regs '"' %{
        set-register '"' %sh{
            $kak_opt_system_paste_command
            # %sh{} trims a trailing newline from its collected output,
            # so we add an extra newline for it to eat.
            echo
        }
        execute-keys %arg{1}
    }
}


map global user y "<a-|>%opt{system_yank_command}<ret>"        -docstring "yank to system clipboard"
map global user p ':execute-keys-with-system-clipboard p<ret>' -docstring "append from system clipboard"
map global user P ':execute-keys-with-system-clipboard P<ret>' -docstring "insert from system clipboard"
map global user R ':execute-keys-with-system-clipboard R<ret>' -docstring "replace from system clipboard"
