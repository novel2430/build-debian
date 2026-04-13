xrdb ~/.Xresources

# xrandr --output DisplayPort-0 \
#  --mode 1920x1080 --rotate left --left-of HDMI-A-0 \
#  --output HDMI-A-0 \
#  --mode 1920x1080 --primary


xrandr --output HDMI-1 --mode 1920x1080 --primary
xrandr --output DP-1 --rotate left --left-of HDMI-1 --mode 1920x1080 --verbose


# exec dbus-run-session openbox-session
# exec dbus-run-session awesome
exec dbus-run-session dwm
