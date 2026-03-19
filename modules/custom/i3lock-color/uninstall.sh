#!/usr/bin/env bash

set -euo pipefail

target_dir="$HOME/src/i3lock-color/build"

# Clone
if [[ -d "$target_dir" ]]; then
  (
    cd $target_dir
    sudo make uninstall
  )
fi
