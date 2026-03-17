#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
target_dir="$HOME/.config/dunst"

mkdir -p "$target_dir"

if [ ! -e "$target_dir/dunstrc" ]; then
	ln -s $SCRIPT_DIR/dunstrc $target_dir/dunstrc
fi
