# misc display settings
compton -b --config /dev/null --backend glx --vsync opengl-swc --glx-no-stencil --opacity-rule="75:class_g='Bspwm' && class_i='presel_feedback'" -f -D 1 -I 0.05 -O 0.05
xsetroot -cursor_name left_ptr
xrdb ~/.Xresources
~/.bin/display.sh
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
sxhkd &
exec bspwm
