#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
target_dir="$HOME/.config/mpv"

mkdir -p "$target_dir"

if [ ! -e "$target_dir/input.conf" ]; then
	ln -s $SCRIPT_DIR/input.conf $target_dir/input.conf
fi
