#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

pics_dir="$HOME/.local/share/pics"
wallpaper_file="$pics_dir/wallpaper"

if [ ! -e "$wallpaper_file" ]; then
  mkdir -p $pics_dir
  ln -s "$SCRIPT_DIR/wall" "$wallpaper_file"
fi
