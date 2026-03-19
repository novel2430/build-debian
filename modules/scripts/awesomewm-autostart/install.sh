#!/usr/bin/env zsh

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

chmod +x $SCRIPT_DIR/awesomewm-autostart.sh
mkdir -p $HOME/.local/bin

if [ ! -e "$HOME/.local/bin/awesomewm-autostart" ]; then
	ln -s $SCRIPT_DIR/awesomewm-autostart.sh $HOME/.local/bin/awesomewm-autostart
fi

