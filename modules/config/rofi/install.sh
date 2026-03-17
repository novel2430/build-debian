#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
target_dir="$HOME/.config/rofi"

mkdir -p "$target_dir"

if [ ! -e "$target_dir/config.rasi" ]; then
	ln -s $SCRIPT_DIR/config.rasi $target_dir/config.rasi
fi
