#!/usr/bin/env bash

repo_dir="$HOME/src/awesomewm-config"
config_dir="$HOME/.config"

if [ ! -e "$repo_dir" ]; then
	git clone https://github.com/novel2430/awesomewm-config.git "$repo_dir"
fi

if [ ! -e "$config_dir/awesome" ]; then
	mkdir -p $config_dir
	ln -s "$repo_dir" "$config_dir/awesome"
fi
