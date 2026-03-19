#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
target_dir="$HOME/.config/sxhkd"
file_name="sxhkdrc"

mkdir -p $target_dir
if [ ! -e "$target_dir/$file_name" ]; then
  ln -s "$SCRIPT_DIR/$file_name" "$target_dir/$file_name"
fi
