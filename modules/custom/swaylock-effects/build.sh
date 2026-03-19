#!/usr/bin/env bash

set -euo pipefail

repo_url="https://github.com/jirutka/swaylock-effects.git"
target_dir="$HOME/src/swaylock-effects"

# Dependecy
sudo apt install -y \
    build-essential \
    meson \
    ninja-build \
    pkg-config \
    libwayland-dev \
    wayland-protocols \
    libxkbcommon-dev \
    libcairo2-dev \
    libgdk-pixbuf-2.0-dev \
    bash-completion \
    git \
    cmake \
    libpam0g-dev \
    scdoc \
    libcrypt-dev \
    libglib2.0-dev \
    libglib2.0-bin

# Clone
if [[ -d "$target_dir" ]]; then
  echo "Swaylock-effects repo exists"
else
  mkdir -p "$target_dir"
  git clone "$repo_url" "$target_dir"
fi

(
  cd "$target_dir"
  git checkout v1.7.0.0
  rm -rf build
  meson setup build
  ninja -C build
)
