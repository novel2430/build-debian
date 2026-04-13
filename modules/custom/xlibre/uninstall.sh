#!/usr/bin/bash env

XLIBRE_REPO_DIR="$HOME/src/xlibre-xserver"
XF86_INPUT_REPO_DIR="$HOME/src/xf86-input-libinput"
XLIBRE_PREFIX_DIR="/usr/local/opt/xlibre/"

if [ -e "$XF86_INPUT_REPO_DIR/build" ]; then
  (
    cd "$XF86_INPUT_REPO_DIR"
    sudo ninja -C build uninstall
  )
fi

if [ -e "$XLIBRE_REPO_DIR/build" ]; then
  (
    cd "$XLIBRE_REPO_DIR"
    sudo ninja -C build uninstall
  )
fi

rm -rf --verbose "$HOME/.local/bin/xlibre-run"
sudo rm -rf --verbose "$XLIBRE_PREFIX_DIR"
