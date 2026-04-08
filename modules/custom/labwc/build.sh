#!/usr/bin/env bash

REPO_URL="https://github.com/labwc/labwc.git"
REPO_DIR="$HOME/src/labwc"

if [ ! -e "$REPO_DIR" ]; then
  git clone "$REPO_URL" "$REPO_DIR"
fi

if [ -e "$REPO_DIR" ]; then
  (
    cd "$REPO_DIR"
    git checkout 0.9.6
    rm -rf build
    meson setup build/ --prefix=/usr/local
    meson compile -C build/
  )
fi
