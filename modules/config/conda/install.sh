#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
target_dir="$HOME"

mkdir -p "$target_dir"

if [ ! -e "$target_dir/.condarc" ]; then
	ln -sf $SCRIPT_DIR/condarc $target_dir/.condarc
fi
