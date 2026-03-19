#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SERVICE_SRC="$SCRIPT_DIR/idle-lock-guard.service"
TARGET_SRC="/etc/systemd/user/idle-lock-guard.service"


if [ ! -e $HOME/.local/bin/idle-lock-guard ]; then
  chmod +x $SCRIPT_DIR/idle-lock-guard.sh
  ln -s $SCRIPT_DIR/idle-lock-guard.sh $HOME/.local/bin/idle-lock-guard
fi

sudo cp --verbose "$SERVICE_SRC" "$TARGET_SRC"
