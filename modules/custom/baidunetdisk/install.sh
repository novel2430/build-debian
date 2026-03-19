#!/usr/bin/env zsh

download_src="/tmp/baidunetdisk_4.17.8_amd64.deb"
release_dir="/opt/baidunetdisk"
desktop_file="/usr/share/applications/baidunetdisk.desktop"
bin_file="/usr/bin/baidunetdisk-bin"

if [[ -e "$bin_file" || -e "$dekstop_file" ]]; then
  echo "Baidu Netdisk already installed!"
  exit 0
fi

if [ ! -e "$download_src" ]; then
	# Installing
	wget "http://wppkg.baidupcs.com/issue/netdisk/Linuxguanjia/4.17.8/baidunetdisk_4.17.8_amd64.deb" -O $download_src
	sudo dpkg -i "$download_src"
fi


# Building Bin
touch /tmp/baidunetdisk-bin
cat > /tmp/baidunetdisk-bin <<'EOF'
#!/usr/bin/env bash
cd /opt/baidunetdisk
GDK_BACKEND=x11 HOME="${HOME:-/tmp}/.local/share/baidu" ./baidunetdisk "$@"
EOF
sudo cp /tmp/baidunetdisk-bin /usr/bin/baidunetdisk-bin
sudo chmod +x /usr/bin/baidunetdisk-bin

# Intalling Icon
sudo install -m 755 $release_dir/baidunetdisk.svg /usr/local/share/icons/hicolor/scalable/apps/baidunetdisk.svg 


# Wrinting Desktop File
touch /tmp/baidunetdisk.desktop
cat > /tmp/baidunetdisk.desktop <<'EOF'
[Desktop Entry]
Name=Baidu Netdisk
Name[zh_CN]=百度网盘
Name[zh_TW]=百度网盘
Exec=/usr/bin/baidunetdisk-bin --no-sandbox %U
Terminal=false
Type=Application
Icon=baidunetdisk
StartupWMClass=baidunetdisk
Comment=百度网盘
Comment[zh_CN]=百度网盘
Comment[zh_TW]=百度网盘
MimeType=x-scheme-handler/baiduyunguanjia;
Categories=Network;
EOF
sudo cp /tmp/baidunetdisk.desktop $desktop_file
