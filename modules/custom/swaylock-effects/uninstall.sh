#!/usr/bin/env bash

set -euo pipefail

target_dir="$HOME/src/swaylock-effects"

if [[ -e "$target_dir/build" ]]; then
  (
    cd "$target_dir"
    sudo ninja -C build uninstall
  )
fi
