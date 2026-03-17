#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
MODULES_DIR="$SCRIPT_DIR/../../modules"
APT_DIR="$MODULES_DIR/apt"
CONFIG_DIR="$MODULES_DIR/config"
CUSTOM_DIR="$MODULES_DIR/custom"
FLATPAK_DIR="$MODULES_DIR/flatpak"
SCRIPTS_DIR="$MODULES_DIR/scripts"
SYSTEMD_DIR="$MODULES_DIR/systemd"

# APT
echo "==== APT Installing ===="
bash "$APT_DIR/apply.sh"

# Custom - Install
echo "==== Custom Package Installing ===="
bash "$CUSTOM_DIR/latex-chinese-fonts/install.sh"
bash "$CUSTOM_DIR/hack-nerd-fonts/install.sh"
bash "$CUSTOM_DIR/mihomo/install.sh"
bash "$CUSTOM_DIR/nodejs/install.sh"
bash "$CUSTOM_DIR/dingtalk/install.sh"
# Custom - Build, Install
echo "==== Custom Package (Build) Installing ===="
bash "$CUSTOM_DIR/wlroots-0.19/build.sh" && bash "$CUSTOM_DIR/wlroots-0.19/install.sh"
bash "$CUSTOM_DIR/dwl/build.sh" && bash "$CUSTOM_DIR/dwl/install.sh"
bash "$CUSTOM_DIR/neovim/build.sh" && bash "$CUSTOM_DIR/neovim/install.sh"
bash "$CUSTOM_DIR/rofi/build.sh" && bash "$CUSTOM_DIR/rofi/install.sh"
bash "$CUSTOM_DIR/wezterm/build.sh" && bash "$CUSTOM_DIR/wezterm/install.sh"
bash "$CUSTOM_DIR/wayfire/build.sh" && bash "$CUSTOM_DIR/wayfire/install.sh"

# Flatpak
echo "==== Flatpak Package Installing ===="
bash "$FLATPAK_DIR/apply.sh"

# Config
echo "==== Config Installing ===="
bash "$CONFIG_DIR/dunst/install.sh"
bash "$CONFIG_DIR/dwl/install.sh"
bash "$CONFIG_DIR/rofi/install.sh"
bash "$CONFIG_DIR/zsh/install.sh"
bash "$CONFIG_DIR/xdg-desktop-portal-wlr/install.sh"

# Scripts
echo "==== Scripts Installing ===="
bash "$SCRIPTS_DIR/dwl-autostart/install.sh"
bash "$SCRIPTS_DIR/grim-slurp-sceenshot/install.sh"
bash "$SCRIPTS_DIR/my-swaylock/install.sh"
bash "$SCRIPTS_DIR/my-volume/install.sh"
bash "$SCRIPTS_DIR/rofi-power-menu/install.sh"
bash "$SCRIPTS_DIR/wlroot-clipboard/install.sh"

# Systemd
echo "==== Systemd Scripts Installing ===="
bash "$SYSTEMD_DIR/mihomo/install.sh"
