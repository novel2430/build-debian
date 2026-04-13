#!/usr/bin/env bash

set -euo pipefail

target_dir="$HOME/src/dwm"

# Clone
if [[ -d "$target_dir" ]]; then
  (
    cd "$target_dir"
    sudo make install
  )
fi
