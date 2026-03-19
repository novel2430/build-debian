#!/usr/bin/env bash

set -euo pipefail

repo_url="https://github.com/neovim/neovim.git"
target_dir="$HOME/src/nvim"

# Dependecy
sudo apt install -y ninja-build gettext cmake curl build-essential git

# Clone
if [[ -d "$target_dir" ]]; then
  echo "Neovim repo exists"
else
  mkdir -p "$target_dir"
  git clone "$repo_url" "$target_dir"
fi

(
  cd "$target_dir"
  git checkout stable
  make clean
  make CMAKE_BUILD_TYPE=RelWithDebInfo
)
