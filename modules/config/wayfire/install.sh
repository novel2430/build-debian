#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
target_dir="$HOME/.config/wayfire"

mkdir -p "$target_dir"

if [ ! -e "$HOME/.config/wayfire.ini" ]; then
	ln -s $SCRIPT_DIR/wayfire.ini $HOME/.config/wayfire.ini
fi

if [ ! -e "$target_dir/waybar.jsonc" ]; then
	ln -s $SCRIPT_DIR/waybar.jsonc $target_dir/waybar.jsonc
fi

if [ ! -e "$target_dir/waybar.css" ]; then
	ln -s $SCRIPT_DIR/waybar.css $target_dir/waybar.css
fi
