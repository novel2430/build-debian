#!/usr/bin/env bash

set -euo pipefail

install_file_txt="$HOME/.local/share/pkg-manifests/mangowc"
if [[ -e "$install_file_txt/install-files.txt" ]]; then
  while IFS= read -r f; do
    sudo rm -rf --verbose "$f"
  done < "$install_file_txt/install-files.txt"
fi
