#!/usr/bin/env bash

set -euo pipefail

repo_url="https://github.com/WayfireWM/wayfire.git"
target_dir="$HOME/src/wayfire"

# Dependecy
sudo apt install -y ninja-build gettext cmake curl build-essential git pkgconf \
  libinput-dev \
  libwayland-dev \
  libxkbcommon-dev \
  wayland-protocols \
  libxcb1-dev \
  libxcb-icccm4-dev \
  xwayland \
  libxml2-dev \
  libglm-dev

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
