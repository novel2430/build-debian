#!/usr/bin/env bash

set -euo pipefail

target_dir="$HOME/src/nvim"

if [[ -e "$target_dir" ]]; then
  (
    cd "$target_dir"
    sudo cmake --build build --target uninstall
  )
fi
