#!/usr/bin/env bash

set -euo pipefail

target_dir="$HOME/src/Waybar"

if [[ -e "$target_dir" ]]; then
  (
    cd "$target_dir"
    sudo ninja -C build uninstall
  )
fi
