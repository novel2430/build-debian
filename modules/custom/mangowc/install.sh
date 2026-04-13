#!/usr/bin/env bash

set -euo pipefail

target_dir="/tmp/mangowc"
install_file_txt="$HOME/.local/share/pkg-manifests/mangowc"

# Clone
if [[ -d "$target_dir" ]]; then
  (
    cd "$target_dir"
    DESTDIR="$PWD/pkg" meson install -C build
    cd "$PWD/pkg"
    find . -type f | sed 's#^\./#/#' | sort
    mkdir -p "$install_file_txt"
    find . -type f | sed 's#^\./#/#' | sort > "$install_file_txt/install-files.txt"
  )
fi

if [[ -e "$install_file_txt/install-files.txt" ]]; then
  while IFS= read -r f; do
    sudo cp --verbose "$target_dir/pkg/$f" "$f"
  done < "$install_file_txt/install-files.txt"
fi
