#!/usr/bin/env bash

REPO_URL="https://github.com/phase1geo/Annotator.git"
REPO_DIR="$HOME/src/Annotator"

if [ ! -e "$REPO_DIR" ]; then
  git clone "$REPO_URL" "$REPO_URL"
fi

if [ -e "$REPO_DIR" ]; then
  (
    cd "$REPO_DIR"
    git checkout 2.0.2
    rm -rf build
    meson setup build --prefix=/usr/local
    ninja -C build
  )
fi
