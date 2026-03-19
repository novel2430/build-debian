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
    dbus-update-activation-environment --systemd DISPLAY XAUTHORITY XDG_CURRENT_DESKTOP
)
systemctl --user stop xdg-desktop-portal xdg-desktop-portal-gtk xdg-desktop-portal-wlr
systemctl --user restart pipewire pipewire-pulse wireplumber
systemctl --user restart xdg-desktop-portal-gtk
systemctl --user restart xdg-desktop-portal
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

systemctl --user restart idle-lock-guard.service
