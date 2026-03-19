#!/usr/bin/env bash

set -euo pipefail

target_dir="$HOME/src/swaylock-effects"

# Clone
if [[ -d "$target_dir/build" ]]; then
  (
    cd "$target_dir"
    sudo ninja -C build install
  )
fi
