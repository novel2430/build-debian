#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SERVICE_SRC="$SCRIPT_DIR/mihomo.service"
TARGET_SRC="/etc/systemd/user/mihomo.service"

sudo cp --verbose "$SERVICE_SRC" "$TARGET_SRC"
