# misc display settings
xrdb ~/.Xresources
xsetroot -cursor_name left_ptr
xsetroot -solid "#32302f" &
redshift -m randr &

# kb & mouse settings
setxkbmap -option ctrl:nocaps -option altwin:swap_lalt_lwin &
xset r rate 500 30 &
xbanish &

# daemons
devmon &
dunst &

# audio
pulseaudio --start

# start wm
exec bspwm
