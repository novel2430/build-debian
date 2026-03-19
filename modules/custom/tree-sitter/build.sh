#!/usr/bin/env bash

set -euo pipefail

repo_url="https://github.com/tree-sitter/tree-sitter.git"
target_dir="$HOME/src/tree-sitter"

# Clone
if [[ -d "$target_dir" ]]; then
  echo "Treesitter repo exists"
else
  mkdir -p "$target_dir"
  git clone "$repo_url" "$target_dir"
fi

(
  cd "$target_dir"
  git checkout v0.25.10
  make clean
  make
)
