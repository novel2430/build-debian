#!/usr/bin/env bash

LOCAL_DESKTOP_DIR="$HOME/.local/share/applications"
LOCAL_ICON_DIR="$HOME/.local/share/icons/hicolor/128x128/apps"
HMCL_OPT_DIR="$HOME/.local/opt/hmcl"
HMCL_ICON_DIR="$LOCAL_ICON_DIR/hmcl.png"
HMCL_DESKTOP_DIR="$LOCAL_DESKTOP_DIR/HMCL.desktop"
HMCL_BIN_DIR="$HOME/.local/bin/hmcl"

rm -rf $HMCL_OPT_DIR
rm -rf $HMCL_ICON_DIR
rm -rf $HMCL_DESKTOP_DIR
rm -rf $HMCL_BIN_DIR
