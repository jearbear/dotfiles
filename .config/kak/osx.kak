set-option global system_yank_command "pbcopy"
set-option global system_paste_command "pbpaste"

hook global ModuleLoaded kitty %{
    set-option global kitty_window_type "window"
}

