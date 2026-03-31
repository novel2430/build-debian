#!/usr/bin/env bash
set -euo pipefail

GHOSTTY_DIR="/usr/local/opt/ghostty"

sudo rm -rf /usr/local/bin/ghostty

sudo rm -rf /usr/local/share/applications/com.mitchellh.ghostty.desktop

ICON_SRC="$GHOSTTY_DIR/share/icons/hicolor"
ICON_DST="/usr/local/share/icons/hicolor"

if [[ -d "$ICON_SRC" ]]; then
    find "$ICON_SRC" -type f -name "*.png" | while read SRC_FILE; do
        REL_PATH="${SRC_FILE#$ICON_SRC/}"
        DST_FILE="$ICON_DST/$REL_PATH"
        if [[ -L "$DST_FILE" ]]; then
            sudo rm "$DST_FILE"
            echo "Removed icon link: $DST_FILE"
        fi
    done
fi

sudo rm -rf "$GHOSTTY_DIR"
