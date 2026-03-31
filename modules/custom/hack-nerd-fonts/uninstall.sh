#!/usr/bin/env bash

font_dir="$HOME/.local/share/fonts/HackNerdFont"

if [ -e "$font_dir" ]; then
  rm -rf $font_dir
fi
