#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SCRIPT_NAME="wayfire-autostart"

chmod +x "$SCRIPT_DIR/$SCRIPT_NAME.sh"
mkdir -p $HOME/.local/bin

if [ ! -e "$HOME/.local/bin/$SCRIPT_NAME" ]; then
	ln -s "$SCRIPT_DIR/$SCRIPT_NAME.sh" "$HOME/.local/bin/$SCRIPT_NAME"
fi

