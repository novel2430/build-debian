#!/usr/bin/env zsh

download_src="/tmp/Hack.zip"
font_dir="$HOME/.local/share/fonts/HackNerdFont"

if [ ! -e "$font_dir" ]; then
	wget "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Hack.zip" -O $download_src
	mkdir -p $font_dir
	unzip $download_src -d $font_dir
	fc-list | grep Hack
fi
