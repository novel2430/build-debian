#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

mkdir -p $HOME/.config
rm -rf $HOME/.config/mimeapps.list
ln -s $SCRIPT_DIR/mimeapps.list $HOME/.config/mimeapps.list
