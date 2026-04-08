#!/usr/bin/env zsh

start-wm $WAYLAND_DISPLAY
# Wallpaper
swaybg -i $HOME/.local/share/pics/wallpaper -m fill &
# Notify
dunst &
# Clipboard <cliphist>
wl-paste --watch cliphist store &
# Bar
waybar -c $HOME/.config/labwc/waybar.jsonc -s $HOME/.config/labwc/waybar.css &
# GTK title bar layout
gsettings set org.gnome.desktop.wm.preferences button-layout ':minimize,maximize,close'
# GRT Dark Theme (fix for GTK4)
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface icon-theme 'Papirus'
# xdg-portal
export XDG_CURRENT_DESKTOP=wlroots
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP DISPLAY XAUTHORITY
killall pipewire; /usr/bin/pipewire &
killall wireplumber; /usr/bin/wireplumber &
killall pipewire-pulse; /usr/bin/pipewire-pulse &
# IME
fcitx5 --replace -d &
# nm-applet
nm-applet &
# For Wemeet
flatpak override --user --env=LD_PRELOAD=/app/lib/wemeet/libhook.so com.tencent.wemeet &
# idle guard
kill -TERM $(pgrep -f idle-lock-guard) 2>/dev/null; idle-lock-guard > $HOME/.log/idle-lock-guard/idle-lock-guard.log 2>&1 &
# wlr-randr settings
if [ ! -z "${WLR_RANDR_CLI}" ]; then
  eval "$WLR_RANDR_CLI"
fi
