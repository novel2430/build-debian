#!/usr/bin/env zsh

download_src="/tmp/image-roll_2.1.0_amd64.deb"

if [ ! -e "$download_src" ]; then
	# Installing
	wget "https://github.com/weclaw1/image-roll/releases/download/2.1.0/image-roll_2.1.0_amd64.deb" -O $download_src
fi
sudo dpkg -i "$download_src"
