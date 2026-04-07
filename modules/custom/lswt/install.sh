#!/usr/bin/env bash

REPO_DIR="$HOME/src/lswt-v2.0.0"
if [ -e "$REPO_DIR" ]; then
  (
    cd "$REPO_DIR"
    sudo make install
  )
fi
