#!/usr/bin/env bash

CUR_DIR="$(cd "$(dirname "$0")" && pwd)"
MODULES_DIR="$CUR_DIR/../../modules"
APT_DIR="$MODULES_DIR/apt"
CONFIG_DIR="$MODULES_DIR/config"
CUSTOM_DIR="$MODULES_DIR/custom"
FLATPAK_DIR="$MODULES_DIR/flatpak"
SCRIPTS_DIR="$MODULES_DIR/scripts"
OPENRC_DIR="$MODULES_DIR/openrc"
SERVICES_DIR="$MODULES_DIR/services"

# APT #
echo "==== APT Installing ===="
bash "$APT_DIR/apply.sh"

# APT Packages for Custom Build #
CUSTOM_BUILD_APT_PACKAGE_FILE="$CUSTOM_DIR/dependency-packages.txt"
if [ -f "$CUSTOM_BUILD_APT_PACKAGE_FILE" ]; then
  echo "==== Custom Build's Apt Package Installing ===="
  grep -vE '^\s*(#|$)' "$CUSTOM_BUILD_APT_PACKAGE_FILE" | xargs -r sudo apt install -y
fi

# Custom - Install #
echo "==== Custom Package Installing ===="
## -- Latex Chinese Fonts (Simsun, Kaiti ...)
bash "$CUSTOM_DIR/latex-chinese-fonts/install.sh"
## -- Hack Nerd Fonts
bash "$CUSTOM_DIR/hack-nerd-fonts/install.sh"
## -- Mihomo (Clash Stuff)
bash "$CUSTOM_DIR/mihomo/install.sh"
## -- Nodejs (npm)
bash "$CUSTOM_DIR/nodejs/install.sh"
## -- DingTalk
bash "$CUSTOM_DIR/dingtalk/install.sh"
## -- Baidu Netdisk
bash "$CUSTOM_DIR/baidunetdisk/install.sh"
## -- Greenclip (X11 clipboard Daemon)
bash "$CUSTOM_DIR/greenclip/install.sh"
## -- HMCL
if [ ! -e "$HOME/.local/bin/hmcl" ]; then
  bash "$CUSTOM_DIR/hmcl/install.sh"
fi
## -- OpenTTD
if [ ! -e "$HOME/.local/bin/openttd" ]; then
  bash "$CUSTOM_DIR/openttd/install.sh"
fi

# Custom - Build and Install #
echo "==== Custom Package (Build) Installing ===="
## ------------------------------------------------
## -- Wlroots 0.19.2 (DWL, Wayfire depend on this)
if pkg-config --exists wlroots-0.19; then
  version=$(pkg-config --modversion wlroots-0.19)
  echo "wlroots-0.19 already installed，version: $version"
else
  bash "$CUSTOM_DIR/wlroots-0.19/build.sh" && bash "$CUSTOM_DIR/wlroots-0.19/install.sh"
  sudo ldconfig
fi
## -- tree-sitter 0.25.10 (Emacs 29.4 tree-sitter depend on this)
if pkg-config --exists tree-sitter; then
  version=$(pkg-config --modversion tree-sitter)
  echo "tree-sitter already installed，version: $version"
else
  bash "$CUSTOM_DIR/tree-sitter/build.sh" && bash "$CUSTOM_DIR/tree-sitter/install.sh"
  sudo ldconfig
fi
## -- scenefx 0.4.1 (Mangowc depend on this)
if pkg-config --exists scenefx-0.4; then
  version=$(pkg-config --modversion scenefx-0.4)
  echo "Scenefx already installed，version: $version"
else
  bash "$CUSTOM_DIR/scenefx/build.sh" && bash "$CUSTOM_DIR/scenefx/install.sh"
  sudo ldconfig
fi
## -- Zig 0.15.2 (Ghostty depend on this)
if [ ! -e /usr/local/bin/zig ]; then
  bash "$CUSTOM_DIR/zig/install.sh"
  sudo ldconfig
fi
## ------------------------------------------------
## -- neovim 0.12.1
if [ ! -e /usr/local/bin/nvim ]; then
  bash "$CUSTOM_DIR/neovim/build.sh" && bash "$CUSTOM_DIR/neovim/install.sh"
fi
## -- dwl 0.8
if [ ! -e /usr/local/bin/dwl ]; then
  bash "$CUSTOM_DIR/dwl/build.sh" && bash "$CUSTOM_DIR/dwl/install.sh"
fi
## -- mangowc 0.12.7
if [ ! -e /usr/local/bin/mango ]; then
  bash "$CUSTOM_DIR/mangowc/build.sh" && bash "$CUSTOM_DIR/mangowc/install.sh"
fi
## -- rofi 2.0.0
if [ ! -e /usr/local/bin/rofi ]; then
  bash "$CUSTOM_DIR/rofi/build.sh" && bash "$CUSTOM_DIR/rofi/install.sh"
fi
## -- waybar 0.15.0
if [ ! -e /usr/local/bin/waybar ]; then
  bash "$CUSTOM_DIR/waybar/build.sh" && bash "$CUSTOM_DIR/waybar/install.sh"
fi
## -- wezterm 577474d
if [ ! -e /usr/local/bin/wezterm ]; then
  bash "$CUSTOM_DIR/wezterm/build.sh" && bash "$CUSTOM_DIR/wezterm/install.sh"
fi
## -- ghostty 1.3.1
if [ ! -e /usr/local/bin/ghostty ]; then
  bash "$CUSTOM_DIR/ghostty/build.sh" && bash "$CUSTOM_DIR/ghostty/install.sh"
fi
## -- swaylock-effects 1.7.0.0
if [ ! -e /usr/local/bin/swaylock ]; then
  bash "$CUSTOM_DIR/swaylock-effects/build.sh" && bash "$CUSTOM_DIR/swaylock-effects/install.sh"
fi
## -- i3lock-color 2.13.c.5
if [ ! -e /usr/local/bin/i3lock ]; then
  bash "$CUSTOM_DIR/i3lock-color/build.sh" && bash "$CUSTOM_DIR/i3lock-color/install.sh"
fi
## -- wayfire 0.10.1-746bc7e9
if [ ! -e /usr/local/bin/wayfire ]; then
  bash "$CUSTOM_DIR/wayfire/build.sh" && bash "$CUSTOM_DIR/wayfire/install.sh"
fi
## -- emacs 29.4
if [ ! -e /usr/local/bin/emacs ]; then
  bash "$CUSTOM_DIR/emacs29/build.sh" && bash "$CUSTOM_DIR/emacs29/install.sh"
fi
## -- Yazi 26.1.22
if [ ! -e /usr/local/bin/yazi ]; then
  bash "$CUSTOM_DIR/yazi/build.sh" && bash "$CUSTOM_DIR/yazi/install.sh"
fi
## -- lswt
if [ ! -e /usr/local/bin/lswt ]; then
  bash "$CUSTOM_DIR/lswt/build.sh" && bash "$CUSTOM_DIR/lswt/install.sh"
fi

# Flatpak #
echo "==== Flatpak Package Installing ===="
bash "$FLATPAK_DIR/apply.sh"

# Config #
echo "==== Config Installing ===="
## ------------------------------------------------
## -- Git config
bash "$CONFIG_DIR/git/install.sh"
## -- SSH
bash "$CONFIG_DIR/ssh/install.sh"
## -- $HOME/.profile 
if [ -e "$CUR_DIR/profile" ]; then
  rm "$HOME/.profile" && ln -s "$CUR_DIR/profile" "$HOME/.profile"
fi
## -- Zsh
bash "$CONFIG_DIR/zsh/install.sh"
## -- Tmux
bash "$CONFIG_DIR/tmux/install.sh"
## -- Neovim
bash "$CONFIG_DIR/nvim/install.sh"
## -- Pip
bash "$CONFIG_DIR/pip/install.sh"
## -- Condarc
bash "$CONFIG_DIR/conda/install.sh"
## ------------------------------------------------
## -- Xdg Destop WLR Config
bash "$CONFIG_DIR/xdg-desktop-portal-wlr/install.sh"
## -- Mimeapps
bash "$CONFIG_DIR/mimeapps/install.sh"
## -- Theme (Gtk)
bash "$CONFIG_DIR/theme/install.sh"
## -- Dunst
bash "$CONFIG_DIR/dunst/install.sh"
## -- Sxhkd
bash "$CONFIG_DIR/sxhkd/install.sh"
## -- Awesome Window Manager
bash "$CONFIG_DIR/awesomewm/install.sh"
## -- DWL (Waybar config)
bash "$CONFIG_DIR/dwl/install.sh"
## -- Mangowc
bash "$CONFIG_DIR/mangowc/install.sh"
## -- Openbox (Openbox config, polybar)
bash "$CONFIG_DIR/openbox/install.sh"
## -- Wayfire (Wayfire config, waybar)
bash "$CONFIG_DIR/wayfire/install.sh"
## -- xinitrc & Xresources
if [[ -e "$CUR_DIR/.xinitrc" && ! -e "$HOME/.xinitrc" ]]; then
  ln -s "$CUR_DIR/.xinitrc" "$HOME/.xinitrc"
fi
if [[ -e "$CUR_DIR/.Xresources" && ! -e "$HOME/.Xresources" ]]; then
  ln -s "$CUR_DIR/.Xresources" "$HOME/.Xresources"
fi
## ------------------------------------------------
## -- Emacs 29.4 
bash "$CONFIG_DIR/emacs29/install.sh"
## -- Mpv
bash "$CONFIG_DIR/mpv/install.sh"
## -- Wallpaper
bash "$CONFIG_DIR/pics/install.sh"
## -- Rofi
bash "$CONFIG_DIR/rofi/install.sh"
## -- Wezterm
bash "$CONFIG_DIR/wezterm/install.sh"
## ------------------------------------------------
## -- Wechat (Flatpak Settings)
bash "$CONFIG_DIR/wechat/install.sh"
## -- Firefox (Flatpak Settings)
bash "$CONFIG_DIR/firefox/install.sh"
## -- WPS 365 (Flatpak Settings)
bash "$CONFIG_DIR/wps365/install.sh"

# Scripts #
echo "==== Scripts Installing ===="
## -- [awesomewm-autostart] : Awesome Window manager autostart script
bash "$SCRIPTS_DIR/awesomewm-autostart/install.sh"
## -- [dwl-autostart] : DWL autostart script
bash "$SCRIPTS_DIR/dwl-autostart/install.sh"
## -- [greenclip-rofi] : show clipboard in X11
bash "$SCRIPTS_DIR/greenclip-rofi/install.sh"
## -- [grim-slurp-screenshot] : screenshot in Wayland
bash "$SCRIPTS_DIR/grim-slurp-screenshot/install.sh"
## -- [maim-screenshot] : screenshot in X11
bash "$SCRIPTS_DIR/maim-screenshot/install.sh"
## -- [my-i3lock] : custom i3lock script
bash "$SCRIPTS_DIR/my-i3lock/install.sh"
## -- [my-swayidle] : custom swayidle script
bash "$SCRIPTS_DIR/my-swayidle/install.sh"
## -- [my-swaylock] : custom swaylock script
bash "$SCRIPTS_DIR/my-swaylock/install.sh"
## -- [my-volume] : wireplumber volume control with notify
bash "$SCRIPTS_DIR/my-volume/install.sh"
## -- [polybar-bat] : show battery info for Polybar
bash "$SCRIPTS_DIR/polybar-bat/install.sh"
## -- [polybar-openbox-launch] : launch Openbox's Polybar
bash "$SCRIPTS_DIR/polybar-openbox-launch/install.sh"
## -- [polybar-temp] : show cpu temperature info for Polybar
bash "$SCRIPTS_DIR/polybar-temp/install.sh"
## -- [rofi-power-menu] : show power menu by Rofi
bash "$SCRIPTS_DIR/rofi-power-menu/install.sh"
## -- [start-wm] : utils for save current Wayland or X11 state on disk
bash "$SCRIPTS_DIR/start-wm/install.sh"
## -- [waybar-modules-temp] : show cpu temperature info for Waybar
bash "$SCRIPTS_DIR/waybar-modules-temp/install.sh"
## -- [waybar-modules-weather] : show weather info for Waybar
bash "$SCRIPTS_DIR/waybar-modules-weather/install.sh"
## -- [wayfire-autostart] : Wayfire autostart script
bash "$SCRIPTS_DIR/wayfire-autostart/install.sh"
## -- [wlroot-clipboard] : show clipboard in Wayland
bash "$SCRIPTS_DIR/wlroot-clipboard/install.sh"
## -- [mangowc-autostart] : Mangowc autostart script
bash "$SCRIPTS_DIR/mangowc-autostart/install.sh"
## -- [idle-lock-guard] : make idle only run when you lock screen (Wayland/X11)
bash "$SCRIPTS_DIR/idle-lock-guard/install.sh"

# Openrc #
echo "==== OpenRC Scripts Installing ===="
## -- [mihomo.service] : run mihomo 
if [ ! -e "$HOME/clash" ]; then
  echo "You need to create $HOME/clash for using mihomo service"
else
  bash "$OPENRC_DIR/mihomo/install.sh"
fi

# Host Specify Things #
echo "==== Host Specity Things Installing ===="
## -- Timeshift Backup
if [ -e "$CUR_DIR/timeshift/install.sh" ]; then
  echo "==== Timeshift Config Installing ===="
  bash "$CUR_DIR/timeshift/install.sh"
fi
## -- Apt Packages
HOST_APT_PACKAGE_FILE="$CUR_DIR/apt-packages.txt"
if [ -f "$HOST_APT_PACKAGE_FILE" ]; then
  echo "==== Apt Package Installing ===="
  grep -vE '^\s*(#|$)' "$HOST_APT_PACKAGE_FILE" | xargs -r sudo apt install -y
fi
## -- Flatpak Packages
HOST_FLATPAK_PACKAGE_FILE="$CUR_DIR/flatpak-packages.txt"
if [ -f "$HOST_FLATPAK_PACKAGE_FILE" ]; then
  echo "==== Flatpak Package Installing ===="
  grep -vE '^\s*(#|$)' "$HOST_FLATPAK_PACKAGE_FILE" | xargs -r flatpak install --user -y
fi
## -- Virtual Machine
bash "$SERVICES_DIR/virt-machine/install.sh"
## -- Wifi
bash "$SERVICES_DIR/wifi/install.sh"

## Ending
sudo ldconfig
echo "==== ALL DONE ! ===="
