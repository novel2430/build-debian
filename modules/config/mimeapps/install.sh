#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

if [ ! -e $HOME/.config/mimeapps.list ]; then
  ln -s $SCRIPT_DIR/mimeapps.list $HOME/.config/mimeapps.list
fi
