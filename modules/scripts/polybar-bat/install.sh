#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SCRIPT_NAME="polybar-bat"

chmod +x "$SCRIPT_DIR/$SCRIPT_NAME.py"
mkdir -p $HOME/.local/bin

if [ ! -e "$HOME/.local/bin/$SCRIPT_NAME" ]; then
	ln -s "$SCRIPT_DIR/$SCRIPT_NAME.py" "$HOME/.local/bin/$SCRIPT_NAME"
fi

