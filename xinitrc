# misc display settings
# compton -b --config /dev/null --backend glx --vsync opengl --opacity-rule="75:class_g='Bspwm' && class_i='presel_feedback'"
compton -b --config /dev/null --backend glx --opacity-rule="85:class_g='Bspwm' && class_i='presel_feedback'"
xsetroot -cursor_name left_ptr
xrdb ~/.Xresources
nitrogen --restore
redshift &

# kb & mouse settings
setxkbmap -option ctrl:nocaps
xset r rate 500 30
xbanish &

# daemons
devmon &
dunst &

# audio
pulseaudio --start

# start wm
exec bspwm
