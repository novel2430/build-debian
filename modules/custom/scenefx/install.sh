#!/usr/bin/env bash

set -euo pipefail

target_dir="$HOME/src/scenefx"

# Clone
if [[ -d "$target_dir" ]]; then
  (
    cd "$target_dir"
    sudo ninja -C build/ install
  )
fi
