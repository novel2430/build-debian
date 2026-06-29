#!/usr/bin/env zsh
# =====================================================================
# 優先步驟 1：立刻宣告並強制匯入 D-Bus 環境變數（這必須是腳本的第一件事！）
# =====================================================================
export XDG_CURRENT_DESKTOP=wlroots
dbus-update-activation-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP DISPLAY XAUTHORITY DBUS_SESSION_BUS_ADDRESS

# =====================================================================
# 優先步驟 2：物理性清理並重啟 Portal（徹底杜絕偶發性死鎖）
# =====================================================================
killall -q xdg-desktop-portal xdg-desktop-portal-wlr xdg-desktop-portal-gtk xdg-document-portal
sleep 0.5 # 給系統半秒鐘反應時間

# 依序拉起 Portal（讓核心 document-portal 先跑是官方推薦順序）
/usr/libexec/xdg-document-portal &
/usr/libexec/xdg-desktop-portal &
/usr/libexec/xdg-desktop-portal-wlr &
/usr/libexec/xdg-desktop-portal-gtk &

# =====================================================================
# 優先步驟 3：啟動音訊（PipeWire 也很依賴正確的 D-Bus 變數）
# =====================================================================
killall -q pipewire wireplumber pipewire-pulse
/usr/bin/pipewire &
/usr/bin/wireplumber &
/usr/bin/pipewire-pulse &

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
