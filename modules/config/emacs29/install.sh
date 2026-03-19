#!/usr/bin/env bash

repo_dir="$HOME/src/.emacs.d"
config_dir="$HOME/.config"

if [ ! -e "$repo_dir" ]; then
	git clone https://github.com/novel2430/.emacs.d.git "$repo_dir"
fi

if [ ! -e "$HOME/.emacs.d" ]; then
	ln -s "$repo_dir" "$HOME/.emacs.d"
  npm install -g @vue/language-server
fi

