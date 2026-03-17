#!/usr/bin/env bash

set -euo pipefail

target_dir="$HOME/.nvm"

if [[ -e "$target_dir" ]]; then
  (
    rm -rf "$target_dir"
  )
fi
