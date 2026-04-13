#!/usr/bin/env bash

set -euo pipefail

target_dir="$HOME/src/dwm"

if [[ -e "$target_dir" ]]; then
  (
    cd "$target_dir"
    sudo make uninstall
  )
fi
