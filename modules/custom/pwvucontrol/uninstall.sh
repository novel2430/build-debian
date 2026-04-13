#!/usr/bin/env bash

REPO_DIR="$HOME/src/pwvucontrol"

if [ -e "$REPO_DIR/build" ]; then
  (
    cd "$REPO_DIR"
    sudo ninja -C build uninstall
  )
fi
