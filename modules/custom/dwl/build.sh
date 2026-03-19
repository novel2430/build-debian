#!/usr/bin/env bash

set -euo pipefail

repo_url="https://github.com/novel2430/DWL.git"
target_dir="$HOME/src/DWL"

# Dependecy
sudo apt install -y build-essential git pkgconf \
  libinput-dev \
  libwayland-dev \
  libxkbcommon-dev \
  wayland-protocols \
  libxcb1-dev \
  libxcb-icccm4-dev \
  xwayland

# Clone
if [[ -d "$target_dir" ]]; then
  echo "DWL repo exists"
else
  mkdir -p "$target_dir"
  git clone "$repo_url" "$target_dir"
fi

(
  cd "$target_dir"
  make clean && rm -rf config.h && make
)
