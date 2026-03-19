#!/usr/bin/env bash

set -euo pipefail

repo_url="https://gitlab.freedesktop.org/wlroots/wlroots.git"
target_dir="$HOME/src/wlroots"

# Clone
if [[ -d "$target_dir" ]]; then
  echo "Wlroots repo exists"
else
  mkdir -p "$target_dir"
  git clone "$repo_url" "$target_dir"
fi

(
  cd "$target_dir"
  git checkout 0.19
  meson setup --reconfigure build/
  ninja -C build/
)
