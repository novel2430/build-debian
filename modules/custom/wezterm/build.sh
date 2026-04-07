#!/usr/bin/env bash

set -euo pipefail

repo_url="https://github.com/wezterm/wezterm.git"
target_dir="$HOME/src/wezterm"

# Clone
if [[ -d "$target_dir" ]]; then
  echo "Wezterm repo exists"
else
  mkdir -p "$target_dir"
  git clone "$repo_url" "$target_dir"
fi

(
  cd "$target_dir"
  git checkout 577474d
  rustup default stable
  git submodule update --init --recursive
  ./get-deps
  cargo clean
  cargo build --release -j4
)
