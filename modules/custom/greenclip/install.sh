#!/usr/bin/env bash

set -euo pipefail

target_dir="$HOME/.local/bin"
src_url="https://github.com/erebe/greenclip/releases/download/v4.2/greenclip"
tmp_dir="/tmp/greenclip"

mkdir -p $target_dir

if [[ ! -e "$target_dir/greenclip" ]]; then
  rm -rf $tmp_dir
  wget $src_url -O $tmp_dir 
  mv $tmp_dir $target_dir/greenclip
  chmod +x $target_dir/greenclip
fi
