#!/usr/bin/env zsh

download_src="/tmp/Motrix_1.8.19_amd64.deb"

if [ ! -e "$download_src" ]; then
	# Installing
	wget "https://github.com/agalwood/Motrix/releases/download/v1.8.19/Motrix_1.8.19_amd64.deb" -O $download_src
fi
sudo dpkg -i "$download_src"
