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
AIRLOCK_BIN_DIR="$CUR_DIR/../../airlock/bin/airlock"

airlock_install() {
  if $AIRLOCK_BIN_DIR info "$1" > /dev/null 2>&1; then
    echo "[$1] Already Installed"
  else
    $AIRLOCK_BIN_DIR install "$1"
  fi
}

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
echo "==== Airlock Package Installing ===="
#### Custom - Basic Dependency ####
## ------------------------------------------------
## -- Wlroots 0.19.2 (DWL, Wayfire depend on this)
airlock_install 'wlroots'
## -- tree-sitter 0.25.10 (Emacs 29.4 tree-sitter depend on this)
airlock_install 'tree-sitter'
## -- scenefx 0.4.1 (Mangowc depend on this)
airlock_install 'scenefx'
## -- Zig 0.15.2 (Ghostty depend on this)
airlock_install 'zig'
## ------------------------------------------------
#### Custom - Fonts ####
## ------------------------------------------------
## -- Latex Chinese Fonts (Simsun, Kaiti ...)
airlock_install 'latex-chinese-fonts'
## -- Hack Nerd Fonts
airlock_install 'HackNerdFont'
## ------------------------------------------------
#### Custom - Must have tool ####
## ------------------------------------------------
## -- tree-sitter-cli 
airlock_install 'tree-sitter-cli'
## -- Mihomo (Clash Stuff)
airlock_install 'mihomo'
## -- Nodejs (npm)
airlock_install 'nvm'
## -- neovim 0.12.1
airlock_install 'neovim'
## -- zju-connect
airlock_install 'zju-connect'
## -- miniconda3
airlock_install 'miniconda3'
## ------------------------------------------------
#### Custom - Terminal ####
## ------------------------------------------------
## -- wezterm 577474d
airlock_install 'wezterm'
## -- ghostty 1.3.1
#airlock_install 'ghostty'
## ------------------------------------------------
#### Custom - Window Manager ####
## ------------------------------------------------
## -- dwl 0.8
airlock_install 'my-dwl'
## -- mangowc 0.12.7
#airlock_install 'mango'
## -- wayfire 0.10.1-746bc7e9
airlock_install 'wayfire'
## -- DWM
airlock_install 'my-dwm'
## -- labwc
#airlock_install 'labwc'
## ------------------------------------------------
#### Custom - Tools for Window Manager ####
## ------------------------------------------------
## -- Greenclip (X11 clipboard Daemon)
airlock_install 'greenclip'
## -- rofi 2.0.0
airlock_install 'rofi'
## -- waybar 0.15.0
airlock_install 'waybar'
## -- swaylock-effects 1.7.0.0
airlock_install 'swaylock-effects'
## -- i3lock-color 2.13.c.5
airlock_install 'i3lock-color'
## -- lswt
airlock_install 'lswt'
## -- quickshell 
#airlock_install 'quickshell'
## ------------------------------------------------
#### Custom - TUI Application ####
## ------------------------------------------------
## -- Yazi 26.1.22
airlock_install 'yazi'
## ------------------------------------------------
#### Custom - GUI Application ####
## ------------------------------------------------
## -- DingTalk
airlock_install 'dingtalk'
## -- Baidu Netdisk
airlock_install 'baidunetdisk'
## -- Wemeet
airlock_install 'wemeet'
## -- Image roll
airlock_install 'image-roll'
## -- Motrix
#airlock_install 'motrix'
## -- Spotify
#airlock_install 'spotify'
## -- emacs 29.4
airlock_install 'emacs'
## -- Annotator
airlock_install 'annotator'
## -- Pwvucontrol
airlock_install 'pwvucontrol'
## -- Riff
airlock_install 'riff'
## ------------------------------------------------
#### Custom - Gaming Application ####
## ------------------------------------------------
## -- HMCL
airlock_install 'hmcl'
## -- OpenTTD
airlock_install 'openttd'
## -- Ryujinx
#airlock_install 'ryujinx'
## -- PPSSPP
#airlock_install 'PPSSPP'
## -- steam
#airlock_install 'steam'
## -- protonplus
#airlock_install 'protonplus'
## -- lutris
#airlock_install 'lutris'
## -- azahar 
#airlock_install 'azahar'
# ## -- Codex
# if [ ! -e "$HOME/.nvm/versions/node/v25.9.0/bin/codex" ]; then
#   bash "$CUSTOM_DIR/codex/install.sh"
# fi

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
## -- labwc
bash "$CONFIG_DIR/labwc/install.sh"
## -- DWM
bash "$CONFIG_DIR/dwm/install.sh"
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
## -- WPS 365 (Flatpak Settings)
bash "$CONFIG_DIR/wps365/install.sh"

# Scripts #
echo "==== Scripts Installing ===="
## -- [awesomewm-autostart] : Awesome Window manager autostart script
bash "$SCRIPTS_DIR/awesomewm-autostart/install.sh"
## -- [dwl-autostart] : DWL autostart script
bash "$SCRIPTS_DIR/dwl-autostart/install.sh"
## -- [dwm-bar-text] : bar text for DWM
bash "$SCRIPTS_DIR/dwm-bar-text/install.sh"
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
# HOST_FLATPAK_PACKAGE_FILE="$CUR_DIR/flatpak-packages.txt"
# if [ -f "$HOST_FLATPAK_PACKAGE_FILE" ]; then
#   echo "==== Flatpak Package Installing ===="
#   grep -vE '^\s*(#|$)' "$HOST_FLATPAK_PACKAGE_FILE" | xargs -r flatpak install --user -y
# fi
## -- Virtual Machine
bash "$SERVICES_DIR/virt-machine/install.sh"
## -- Wifi
bash "$SERVICES_DIR/wifi/install.sh"

## Ending
sudo ldconfig
sudo glib-compile-schemas /usr/local/share/glib-2.0/schemas
sudo update-icon-caches /usr/local/share/icons

sudo dbus-uuidgen --ensure=/etc/machine-id
echo "==== ALL DONE ! ===="
