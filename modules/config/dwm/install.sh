#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

mkdir -p $HOME/.dwm

if [ ! -e "$HOME/.dwm/autostart.sh" ]; then
  chmod +x "$SCRIPT_DIR/autostart.sh" 
  ln -sf "$SCRIPT_DIR/autostart.sh" "$HOME/.dwm/autostart.sh"
fi
