#!/usr/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
theme_dir="$HOME/.themes/mytheme"
config_dir="$HOME/.config/openbox"

# Theme
mkdir -p $theme_dir
if [ ! -e "$theme_dir/openbox-3" ]; then
  ln -s "$SCRIPT_DIR/mytheme" "$theme_dir/openbox-3"
fi

# Config
mkdir -p $config_dir
if [ ! -e "$config_dir/rc.xml" ]; then
  ln -s "$SCRIPT_DIR/rc.xml" "$config_dir/rc.xml"
fi
if [ ! -e "$config_dir/menu.xml" ]; then
  ln -s "$SCRIPT_DIR/menu.xml" "$config_dir/menu.xml"
fi

# Autostart
if [ ! -e "$config_dir/autostart" ]; then
  chmod +x "$SCRIPT_DIR/autostart.sh"
  ln -s "$SCRIPT_DIR/autostart.sh" "$config_dir/autostart"
fi

# Polybar
if [ ! -e "$config_dir/config.ini" ]; then
  ln -s "$SCRIPT_DIR/config.ini" "$config_dir/config.ini"
fi
