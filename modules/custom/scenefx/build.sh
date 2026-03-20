#!/usr/bin/env bash

set -euo pipefail

repo_url="https://github.com/wlrfx/scenefx.git"
target_dir="$HOME/src/scenefx"

# Clone
if [[ -d "$target_dir" ]]; then
  echo "Scenefx repo exists"
else
  mkdir -p "$target_dir"
  git clone "$repo_url" "$target_dir"
fi

(
  cd "$target_dir"
  git checkout 0.4.1
  meson setup --reconfigure build/
  ninja -C build/
)
