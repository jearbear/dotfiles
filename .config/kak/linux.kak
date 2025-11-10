set-option global system_yank_command "wl-copy"
set-option global system_paste_command "wl-paste"

hook global ModuleLoaded kitty %{
    set-option global kitty_window_type "os-window"
}
