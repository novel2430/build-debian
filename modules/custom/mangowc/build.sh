#!/usr/bin/env bash

set -euo pipefail

repo_url="https://github.com/mangowm/mango.git"
target_dir="$HOME/src/mangowc"

# Clone
if [[ -d "$target_dir" ]]; then
  echo "Mangowc repo exists"
else
  mkdir -p "$target_dir"
  git clone "$repo_url" "$target_dir"
fi

(
  cd "$target_dir"
  git checkout 0.12.8
  rm -rf build && meson setup --prefix "/usr/local" --reconfigure build/
  ninja -C build/
)
