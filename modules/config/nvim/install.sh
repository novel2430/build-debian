#!/usr/bin/env bash

repo_dir="$HOME/src/nvim-config"
config_dir="$HOME/.config"

if [ ! -e "$repo_dir" ]; then
	git clone https://github.com/novel2430/nvim.git "$repo_dir"
fi

if [ ! -e "$config_dir/nvim" ]; then
	mkdir -p $config_dir
	ln -s "$repo_dir" "$config_dir/nvim"
fi
