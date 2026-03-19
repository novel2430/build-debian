#!/usr/bin/env bash

set -euo pipefail

repo_url="https://github.com/jirutka/swaylock-effects.git"
target_dir="$HOME/src/swaylock-effects"

# Clone
if [[ -d "$target_dir" ]]; then
  echo "Swaylock-effects repo exists"
else
  mkdir -p "$target_dir"
  git clone "$repo_url" "$target_dir"
fi

(
  cd "$target_dir"
  git checkout v1.7.0.0
  rm -rf build
  meson setup build
  ninja -C build
)
