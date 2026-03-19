#!/usr/bin/env bash

src_dir="$HOME/src/emacs-29.4"

if [ -e "$src_dir" ]; then
  (
    cd "$src_dir"
    sudo make uninstall
    sudo rm -rf /usr/local/bin/emacs
  )
fi
