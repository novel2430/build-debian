#!/usr/bin/env zsh

start-wm X11
# Wallpaper
feh --bg-fill $HOME/.local/share/pics/wallpaper &
# Notify
dunst &
# Clipboard <Greenclip>
greenclip daemon &
# GTK title bar layout
gsettings set org.gnome.desktop.wm.preferences button-layout ':minimize,maximize,close'
# GRT Dark Theme (fix for GTK4)
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface icon-theme 'Papirus'
# xdg-portal
(
  unset WAYLAND_DISPLAY
  env XDG_CURRENT_DESKTOP=openbox \
    dbus-update-activation-environment --systemd DISPLAY XAUTHORITY XDG_CURRENT_DESKTOP DBUS_SESSION_BUS_ADDRESS
)
killall pipewire; /usr/bin/pipewire &
killall wireplumber; /usr/bin/wireplumber &
killall pipewire-pulse; /usr/bin/pipewire-pulse &
pgrep -x xdg-document-portal >/dev/null || /usr/libexec/xdg-document-portal &
pgrep -x xdg-desktop-portal >/dev/null || /usr/libexec/xdg-desktop-portal &
pgrep -x xdg-desktop-portal-gtk >/dev/null || /usr/libexec/xdg-desktop-portal-gtk &
pgrep -x xdg-desktop-portal-gtk >/dev/null || /usr/libexec/xdg-desktop-portal-wlr &
# Bar <Polybar>
polybar-openbox-launch &
# Sxhkd
sxhkd &
# IME
fcitx5 --replace -d &
# Idle DPMS (sec)
xset s off
xset s noblank
xset -dpms
# Keyboard speed rate
xset r rate 300 50
# nm-applet
nm-applet &
# For Wemeet
flatpak override --user --unset-env=LD_PRELOAD com.tencent.wemeet &

kill -TERM $(pgrep -f idle-lock-guard) 2>/dev/null; idle-lock-guard > $HOME/.log/idle-lock-guard/idle-lock-guard.log 2>&1 &
