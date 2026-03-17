#!/usr/bin/env zsh

download_src="/tmp/latex-chinese-fonts.zip"
font_dir="$HOME/.local/share/fonts"

if [ ! -e "$HOME/.local/share/fonts/latex-chinese-fonts-master" ]; then
	wget "https://github.com/Haixing-Hu/latex-chinese-fonts/archive/refs/heads/master.zip" -O $download_src
	mkdir -p $font_dir
	unzip $download_src -d $font_dir
	fc-list | grep "latex-chinese-fonts-master"
fi
