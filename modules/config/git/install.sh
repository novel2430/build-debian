#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
target_dir="$HOME"

if [ ! -e "$target_dir/.gitconfig" ]; then
	mkdir -p $target_dir
	ln -s $SCRIPT_DIR/gitconfig $target_dir/.gitconfig
fi
