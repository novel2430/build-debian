#!/usr/bin/env bash

set -euo pipefail

src_url="https://repo.anaconda.com/miniconda/Miniconda3-py313_26.1.1-1-Linux-x86_64.sh"
download_src="/tmp/Miniconda3-Linux-x86_64.sh"

if [[ ! -e "$download_src" ]]; then
  wget "$src_url" -O "$download_src"
fi

if [[ -e "$download_src" ]]; then
  bash "$download_src"
fi
