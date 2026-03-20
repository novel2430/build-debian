#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
target_dir="$HOME/.config/mango"

mkdir -p "$target_dir"

if [ ! -e "$target_dir/config.conf" ]; then
	ln -s $SCRIPT_DIR/config.conf $target_dir/config.conf
fi

if [ ! -e "$target_dir/waybar.jsonc" ]; then
	ln -s $SCRIPT_DIR/waybar.jsonc $target_dir/waybar.jsonc
fi

if [ ! -e "$target_dir/waybar.css" ]; then
	ln -s $SCRIPT_DIR/waybar.css $target_dir/waybar.css
fi
