#!/usr/bin/env bash

REPO_DIR="$HOME/src/pwvucontrol"

if [ -e "$REPO_DIR/build" ]; then
  (
    cd "$REPO_DIR"
    sudo meson install -C build
  )
fi
