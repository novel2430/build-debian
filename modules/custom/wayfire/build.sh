#!/usr/bin/env bash

set -euo pipefail

repo_url="https://github.com/WayfireWM/wayfire.git"
target_dir="$HOME/src/wayfire"

# Clone
if [[ -d "$target_dir" ]]; then
  echo "Wayfire repo exists"
else
  mkdir -p "$target_dir"
  git clone "$repo_url" "$target_dir"
fi

(
  cd "$target_dir"
  git checkout v0.10.1
  meson build && ninja -C build
)
