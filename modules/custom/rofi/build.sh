#!/usr/bin/env bash

set -euo pipefail

repo_url="https://github.com/davatorium/rofi.git"
target_dir="$HOME/src/rofi"

# Clone
if [[ -d "$target_dir" ]]; then
  echo "Rofi repo exists"
else
  mkdir -p "$target_dir"
  git clone "$repo_url" "$target_dir"
fi

(
  cd "$target_dir"
  git checkout 2.0.0
  meson setup build --reconfigure
  ninja -C build
)
