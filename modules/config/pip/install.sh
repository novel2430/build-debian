#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
target_dir="$HOME/.config/pip"

mkdir -p "$target_dir"

if [ ! -e "$target_dir/config.rasi" ]; then
	ln -sf $SCRIPT_DIR/pip.conf $target_dir/pip.conf
fi
