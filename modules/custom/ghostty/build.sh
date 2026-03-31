#!/usr/bin/env bash

set -euo pipefail

repo_url="https://github.com/ghostty-org/ghostty.git"
target_dir="$HOME/src/ghostty"

# Clone
if [[ -d "$target_dir" ]]; then
  echo "Ghostty repo exists"
else
  mkdir -p "$target_dir"
  git clone "$repo_url" "$target_dir"
fi

(
  unset http_proxy
  unset https_proxy
  cd "$target_dir"
  git checkout v1.3.1
  zig build -Doptimize=ReleaseFast 
)
