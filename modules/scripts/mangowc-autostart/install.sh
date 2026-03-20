#!/usr/bin/env zsh

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

chmod +x $SCRIPT_DIR/mangowc-autostart.sh
mkdir -p $HOME/.local/bin

if [ ! -e "$HOME/.local/bin/mangowc-autostart" ]; then
	ln -s $SCRIPT_DIR/mangowc-autostart.sh $HOME/.local/bin/mangowc-autostart
fi

