#!/usr/bin/env bash

set -euo pipefail

repo_url="https://github.com/Raymo111/i3lock-color.git"
target_dir="$HOME/src/i3lock-color"

# Dependecy
sudo apt install -y autoconf gcc make pkgconf \
  libpam0g-dev libcairo2-dev libfontconfig1-dev \
  libxcb-composite0-dev libev-dev libx11-xcb-dev \
  libxcb-xkb-dev libxcb-xinerama0-dev libxcb-randr0-dev \
  libxcb-image0-dev libxcb-util0-dev libxcb-xrm-dev \
  libxkbcommon-dev libxkbcommon-x11-dev libjpeg-dev \
  libgif-dev

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
