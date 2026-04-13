#!/usr/bin/env bash

set -euo pipefail

repo_url="https://github.com/Alexays/Waybar.git"
target_dir="$HOME/src/Waybar"

# Clone
if [[ -d "$target_dir" ]]; then
  echo "Waybar repo exists"
else
  mkdir -p "$target_dir"
  git clone "$repo_url" "$target_dir"
fi

(
  cd "$target_dir"
  git checkout 0.15.0
  rm -rf build
  meson setup build --prefix=/usr/local \
    -Dtests=disabled \
    --buildtype=release \
    -Dexperimental=true \
    -Dniri=true \
    -Ddbusmenu-gtk=enabled \
    --wipe
  ninja -C build -j4
)
