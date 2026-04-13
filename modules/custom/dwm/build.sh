#!/usr/bin/env bash

set -euo pipefail

repo_url="https://github.com/novel2430/dwm-6.8.git"
target_dir="$HOME/src/dwm"

# Clone
if [[ -d "$target_dir" ]]; then
  echo "DWM repo exists"
else
  mkdir -p "$target_dir"
  git clone "$repo_url" "$target_dir"
fi

(
  cd "$target_dir"
  make clean && rm -rf config.h && make
)
