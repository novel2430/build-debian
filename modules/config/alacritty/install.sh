#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
target_dir="$HOME/.config"

if [ ! -e "$target_dir/alacritty.toml" ]; then
	mkdir -p $target_dir
	ln -s $SCRIPT_DIR/alacritty.toml $target_dir/alacritty.toml
fi
