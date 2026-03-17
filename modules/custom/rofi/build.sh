#!/usr/bin/env bash

set -euo pipefail

repo_url="https://github.com/davatorium/rofi.git"
target_dir="$HOME/src/rofi"

# Dependecy
sudo apt install \
  build-essential \
  meson ninja-build pkgconf \
  flex bison check \
  libpango1.0-dev \
  libcairo2-dev \
  libglib2.0-dev \
  libgdk-pixbuf-2.0-dev \
  libstartup-notification0-dev \
  libxkbcommon-dev \
  libxkbcommon-x11-dev \
  libxcb1-dev \
  libxcb-xkb-dev \
  libxcb-randr0-dev \
  libxcb-xinerama0-dev \
  libxcb-util-dev \
  libxcb-ewmh-dev \
  libxcb-icccm4-dev \
  libxcb-cursor-dev \
  wayland-protocols \
  libwayland-dev

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
  meson setup build
  ninja -C build
)
