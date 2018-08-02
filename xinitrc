# misc display settings
xrdb ~/.Xresources
xsetroot -cursor_name left_ptr
xsetroot -solid "#32302f" &
redshift -m randr &

# kb & mouse settings
setxkbmap -option ctrl:nocaps &
xset r rate 500 30 &
xbanish &

# daemons
devmon &
dunst &

# start wm
exec bspwm
