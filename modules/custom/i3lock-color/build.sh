#!/usr/bin/env bash

set -euo pipefail

repo_url="https://github.com/Raymo111/i3lock-color.git"
target_dir="$HOME/src/i3lock-color"

# Clone
if [[ -d "$target_dir" ]]; then
  echo "i3lock-color repo exists"
else
  mkdir -p "$target_dir"
  git clone "$repo_url" "$target_dir"
fi
#
(
  cd "$target_dir"
  git checkout 2.13.c.5
  rm -rf build && mkdir -p build && cd build
  ../configure --prefix=/usr/local --sysconfdir=/usr/local/etc
  make
)
