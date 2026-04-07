#!/usr/bin/env bash

SRC_URL="https://git.sr.ht/~leon_plickat/lswt/archive/v2.0.0.tar.gz"
SRC_DIR="/tmp/lswt.tar.gz"
REPO_DIR="$HOME/src/lswt-v2.0.0"

if [ ! -e "$REPO_DIR" ]; then
  wget "$SRC_URL" -O "$SRC_DIR"
  tar -xf "$SRC_DIR" -C $HOME/src
fi

if [ -e "$REPO_DIR" ]; then
  (
    cd "$REPO_DIR"
    make clean
    make
  )
fi
