#!/usr/bin/env bash

set -euo pipefail

target_dir="$HOME/src/ghostty/zig-out"

if [[ -d "$target_dir" ]]; then
  sudo mkdir -p /usr/local/opt/ghostty
  sudo cp -r --verbose $target_dir/* /usr/local/opt/ghostty/

  sudo ln -s /usr/local/opt/ghostty/bin/ghostty /usr/local/bin/ghostty
  sudo ln -s /usr/local/opt/ghostty/share/applications/com.mitchellh.ghostty.desktop /usr/local/share/applications/com.mitchellh.ghostty.desktop

  # Icon
  ICON_DIR="/usr/local/opt/ghostty/share/icons/hicolor"
  DST_DIR="/usr/local/share/icons/hicolor"
  find "$ICON_DIR" -type f -name "*.png" | while read SRC_FILE; do
    REL_PATH="${SRC_FILE#$ICON_DIR/}"
    DST_FILE="$DST_DIR/$REL_PATH"
    sudo mkdir -p "$(dirname "$DST_FILE")"
    sudo ln -sf "$SRC_FILE" "$DST_FILE"
  done
fi
