#!/usr/bin/env bash

REPO_DIR="$HOME/src/Annotator"

if [ -e "$REPO_DIR/build" ]; then
  (
    cd "$REPO_DIR"
    sudo ninja -C build install
  )
fi

if [ -e "/usr/local/bin/com.github.phase1geo.annotator" ]; then
  sudo ln -sf "/usr/local/bin/com.github.phase1geo.annotator" "/usr/local/bin/annotator"
fi
