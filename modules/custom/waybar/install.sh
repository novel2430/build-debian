#!/usr/bin/env bash

set -euo pipefail

target_dir="$HOME/src/Waybar"

# Clone
if [[ -d "$target_dir" ]]; then
  (
    cd "$target_dir"
    sudo ldconfig
    sudo ninja -C build install
  )
fi
