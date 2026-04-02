#!/usr/bin/env bash

set -euo pipefail

target_dir="$HOME/src/nvim"

# Clone
if [[ -d "$target_dir" ]]; then
  (
    cd "$target_dir"
    sudo make install
  )
fi

# For tree-sitter cli
src_url="https://github.com/tree-sitter/tree-sitter/releases/download/v0.26.8/tree-sitter-linux-x64.gz"
dwn_dir="/tmp/tree-sitter-linux-x64.gz"
src_dir="$HOME/.local/bin/tree-sitter"
if [[ ! -e "$dwn_dir" ]]; then
  wget "$src_url" -O "$dwn_dir"
fi
if [[ ! -e "$src_dir" ]]; then
  gzip -d "$dwn_dir" -c > "$src_dir"
  chmod +x "$src_dir"
fi

