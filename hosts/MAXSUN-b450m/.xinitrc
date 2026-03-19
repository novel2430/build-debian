xrdb ~/.Xresources

xrandr --output DisplayPort-0 \
  --mode 1920x1080 --rotate left --left-of HDMI-A-0 \
  --output HDMI-A-0 \
  --mode 1920x1080 --primary



# exec openbox-session
exec awesome
