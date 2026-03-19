#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
target_dir="$HOME"

mkdir -p "$target_dir"

if [ ! -e "$target_dir/.tmux.conf" ]; then
	ln -s $SCRIPT_DIR/tmux.conf $target_dir/.tmux.conf
fi
