#!/usr/bin/env zsh

start-wm $WAYLAND_DISPLAY
# Monitors
# ${opt-config.wl-monitors-cli}
# Wallpaper
swaybg -i $HOME/.local/share/pics/wallpaper -m fill &
# Notify
dunst &
# Clipboard <cliphist>
wl-paste --watch cliphist store &
# Bar
waybar -c $HOME/.config/dwl/waybar.jsonc -s $HOME/.config/dwl/waybar.css &
# GTK title bar layout
gsettings set org.gnome.desktop.wm.preferences button-layout ':minimize,maximize,close'
# GRT Dark Theme (fix for GTK4)
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface icon-theme 'Papirus'
# xdg-portal
export XDG_CURRENT_DESKTOP=wlroots
systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP DISPLAY XAUTHORITY
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP DISPLAY XAUTHORITY
systemctl --user stop pipewire pipewire-pulse wireplumber xdg-desktop-portal xdg-desktop-portal-wlr xdg-desktop-portal-gtk xdg-desktop-portal-gnome
systemctl --user start pipewire pipewire-pulse wireplumber xdg-desktop-portal xdg-desktop-portal-wlr xdg-desktop-portal-gtk
# Swayidle
# my-swayidle &
# IME
fcitx5 --replace -d &
# Blueman-applet
# ${blutooth-cmd}
# nm-applet
nm-applet &
# For Wemeet
flatpak override --user --env=LD_PRELOAD=/app/lib/wemeet/libhook.so com.tencent.wemeet &

systemctl --user restart idle-lock-guard.service

# wlr-randr settings
if [ ! -z "${WLR_RANDR_CLI}" ]; then
  eval "$WLR_RANDR_CLI"
fi
