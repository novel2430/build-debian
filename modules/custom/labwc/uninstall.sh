#!/usr/bin/env bash

REPO_DIR="$HOME/src/labwc"

if [ -e "$REPO_DIR/build" ]; then
  (
    cd "$REPO_DIR/build"
    sudo meson --internal uninstall
  )
fi
