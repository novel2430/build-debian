#!/usr/bin/env bash

repo_dir="$HOME/src/hyprland-config"
config_dir="$HOME/.config"

if [ ! -e "$repo_dir" ]; then
	git clone https://github.com/novel2430/hyprland-config.git "$repo_dir"
fi

if [ ! -e "$config_dir/hypr" ]; then
	mkdir -p $config_dir
	ln -s "$repo_dir" "$config_dir/hypr"
fi
