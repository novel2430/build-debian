#!/usr/bin/env zsh

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

chmod +x $SCRIPT_DIR/dwl-autostart.sh
mkdir -p $HOME/.local/bin

if [ ! -e "$HOME/.local/bin/dwl-autostart" ]; then
	ln -s $SCRIPT_DIR/dwl-autostart.sh $HOME/.local/bin/dwl-autostart
fi

