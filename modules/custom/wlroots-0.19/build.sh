#!/usr/bin/env bash

set -euo pipefail

repo_url="https://gitlab.freedesktop.org/wlroots/wlroots.git"
target_dir="$HOME/src/wlroots"

# Dependecy
sudo apt install -y \
  meson pkgconf \
  libwayland-dev wayland-protocols \
  libegl1-mesa-dev libgles2-mesa-dev \
  libvulkan-dev glslang-tools \
  libdrm-dev libgbm-dev \
  libinput-dev libxkbcommon-dev libudev-dev \
  libpixman-1-dev libseat-dev hwdata \
  libdisplay-info-dev libliftoff-dev \
  liblcms2-dev libcairo2-dev \
  xwayland \
  libxcb1-dev \
  libxcb-render-util0-dev \
  libxcb-icccm4-dev \
  libxcb-errors-dev \
  libxcb-dri3-dev \
  libxcb-composite0-dev \
  libxcb-present-dev \
  libxcb-ewmh-dev libxcb-xinput-dev libxcb-res0-dev

# Clone
if [[ -d "$target_dir" ]]; then
  echo "Wlroots repo exists"
else
  mkdir -p "$target_dir"
  git clone "$repo_url" "$target_dir"
fi

(
  cd "$target_dir"
  git checkout 0.19
  meson setup --reconfigure build/
  ninja -C build/
)
