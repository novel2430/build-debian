#!/usr/bin/env bash

repo_dir="$HOME/src/wezterm-config"
config_dir="$HOME/.config"

if [ ! -e "$repo_dir" ]; then
	git clone https://github.com/novel2430/wezterm-config.git "$repo_dir"
	mkdir -p $config_dir
	ln -s "$repo_dir" "$config_dir/wezterm"
fi

if [ ! -e "$config_dir/wezterm" ]; then
	mkdir -p $config_dir
	ln -s "$repo_dir" "$config_dir/wezterm"
fi
