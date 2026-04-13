#!/usr/bin/env bash

REPO_URL="https://github.com/saivert/pwvucontrol.git"
REPO_DIR="$HOME/src/pwvucontrol"

if [ ! -e "$REPO_DIR" ]; then
  git clone "$REPO_URL" "$REPO_URL"
fi

if [ -e "$REPO_DIR" ]; then
  (
    cd "$REPO_DIR"
    git checkout wp-0.5
    rustup default stable
    rm -rf build
    meson setup build --prefix=/usr/local
    ninja -C build
  )
fi
