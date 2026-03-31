#!/usr/bin/env bash
set -euo pipefail

rm -rf $HOME/.local/bin/openttd

rm -rf $HOME/.local/share/applications/openttd.desktop

ICON_SRC="$HOME/.local/opt/openttd/share/icons/hicolor"
ICON_DST="$HOME/.local/share/icons/hicolor"

if [[ -d "$ICON_SRC" ]]; then
    find "$ICON_SRC" -type f -name "*.png" | while read SRC_FILE; do
        REL_PATH="${SRC_FILE#$ICON_SRC/}"
        DST_FILE="$ICON_DST/$REL_PATH"
        if [[ -L "$DST_FILE" ]]; then
            rm "$DST_FILE"
            echo "Removed icon link: $DST_FILE"
        fi
    done
fi

rm -rf "$HOME/.local/opt/openttd"
