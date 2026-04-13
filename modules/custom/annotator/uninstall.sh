#!/usr/bin/env bash

REPO_DIR="$HOME/src/Annotator"

if [ -e "$REPO_DIR/build" ]; then
  (
    cd "$REPO_DIR"
    sudo ninja -C build uninstall
  )
fi

sudo rm -rf /usr/local/bin/annotator
