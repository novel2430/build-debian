#!/usr/bin/env bash

repo_url="https://github.com/novel2430/com.tencent.wemeet.git"
repo_dir="$HOME/src/com.tencent.wemeet"

if [ ! -e $repo_dir ]; then
  git clone $repo_url $repo_dir
fi

sudo apt install -y flatpak-builder 
flatpak --user install -y flathub \
  org.freedesktop.Platform//24.08 \
  org.freedesktop.Sdk//24.08

(
  cd $repo_dir
  flatpak-builder build-dir com.tencent.wemeet.yml --install --user --force-clean
)
