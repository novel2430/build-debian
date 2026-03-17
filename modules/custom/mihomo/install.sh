#!/usr/bin/env bash

set -euo pipefail

target_url="https://github.com/MetaCubeX/mihomo/releases/download/v1.19.21/mihomo-linux-amd64-v1-v1.19.21.deb"
target_dir="/tmp/mihomo-linux-amd64-v1-v1.19.21.deb"

if [ ! -e "/usr/bin/mihomo" ]; then
	wget "$target_url" -O "$target_dir"
	sudo dpkg -i "$target_dir"
fi
