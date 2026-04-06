#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SERVICE_SRC="$SCRIPT_DIR/mihomo.sh"
TARGET_SRC="/etc/init.d/mihomo"

mkdir -p $HOME/.log/mihomo

if [ ! -e "$TARGET_SRC" ]; then
  sudo cp --verbose "$SERVICE_SRC" "$TARGET_SRC"
  sudo chmod +x "$TARGET_SRC"
  sudo rc-service mihomo start
  sudo rc-update add mihomo default
fi
