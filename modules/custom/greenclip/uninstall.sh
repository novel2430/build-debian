#!/usr/bin/env bash

set -euo pipefail

target_dir="$HOME/.local/bin/greenclip"

if [[ -e "$target_dir" ]]; then
  rm -rf "$target_dir"
fi
