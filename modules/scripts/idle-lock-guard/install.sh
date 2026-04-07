#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

mkdir -p $HOME/.log/idle-lock-guard

if [ ! -e $HOME/.local/bin/idle-lock-guard ]; then
  chmod +x $SCRIPT_DIR/idle-lock-guard.sh
  ln -s $SCRIPT_DIR/idle-lock-guard.sh $HOME/.local/bin/idle-lock-guard
fi
