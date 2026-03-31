#!/usr/bin/env bash

set -euo pipefail

target_dir="$HOME/src/yazi/target/release"

if [[ -d "$target_dir" ]]; then
  sudo install -m 755 $target_dir/yazi /usr/local/bin
  sudo install -m 755 $target_dir/ya /usr/local/bin
fi
