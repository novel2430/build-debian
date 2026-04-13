#!/usr/bin/env bash

set -euo pipefail

repo_url="https://github.com/sxyazi/yazi.git"
target_dir="/tmp/yazi"

# Clone
if [[ -d "$target_dir" ]]; then
  echo "Yazi repo exists"
else
  mkdir -p "$target_dir"
  git clone "$repo_url" "$target_dir"
fi

(
  cd "$target_dir"
  git checkout v26.1.22
  rustup default stable
  cargo clean
  cargo build --release --locked -j4
)
