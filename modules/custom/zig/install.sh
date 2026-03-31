#!/usr/bin/env bash

download_src="/tmp/zig-x86_64-linux-0.15.2.tar.xz"
download_dir="/tmp/zig-x86_64-linux-0.15.2"
BIN_DIR="/usr/local/bin/zig"

if [[ -e "$BIN_DIR" ]]; then
  echo "Zig 0.15.2 already installed!"
  exit 0
fi

if [ ! -e "$download_src" ]; then
	# Installing
	wget "https://ziglang.org/download/0.15.2/zig-x86_64-linux-0.15.2.tar.xz" -O $download_src
fi

if [ ! -e "$download_dir" ]; then
  tar -xvf $download_src -C /tmp
fi

if [ ! -e "$BIN_DIR" ]; then
  sudo cp --verbose "$download_dir/zig" /usr/local/bin/zig
  sudo cp -r --verbose "$download_dir/lib" /usr/local/lib/zig
fi
