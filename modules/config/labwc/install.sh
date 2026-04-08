#!/usr/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
theme_dir="$HOME/.themes/mytheme"
config_dir="$HOME/.config/labwc"

# Theme
mkdir -p $theme_dir
if [ ! -e "$theme_dir/labwc" ]; then
  ln -sf "$SCRIPT_DIR/mytheme" "$theme_dir/labwc"
fi

# Config
mkdir -p $config_dir
if [ ! -e "$config_dir/rc.xml" ]; then
  ln -sf "$SCRIPT_DIR/rc.xml" "$config_dir/rc.xml"
fi
if [ ! -e "$config_dir/menu.xml" ]; then
  ln -sf "$SCRIPT_DIR/menu.xml" "$config_dir/menu.xml"
fi

# Autostart
if [ ! -e "$config_dir/autostart" ]; then
  chmod +x "$SCRIPT_DIR/autostart.sh"
  ln -sf "$SCRIPT_DIR/autostart.sh" "$config_dir/autostart"
fi

# Waybar
if [ ! -e "$config_dir/waybar.jsonc" ]; then
  ln -sf "$SCRIPT_DIR/waybar.jsonc" "$config_dir/waybar.jsonc"
fi
if [ ! -e "$config_dir/waybar.css" ]; then
  ln -sf "$SCRIPT_DIR/waybar.css" "$config_dir/waybar.css"
fi
