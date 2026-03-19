#!/usr/bin/env zsh

download_src="/tmp/com.alibabainc.dingtalk_8.1.0.6021101_amd64.deb"
release_dir="/opt/apps/com.alibabainc.dingtalk/files/8.1.0-Release.6021101"
desktop_file="/usr/share/applications/com.alibabainc.dingtalk.desktop"
BIN_DIR="/usr/bin/dingtalk-bin"


if [[ -e "$BIN_DIR" ||  -e "$desktop_file" ]]; then
  echo "Dingtalk already installed!"
  exit 0
fi

if [ ! -e "$download_src" ]; then
	# Installing
	wget "https://dtapp-pub.dingtalk.com/dingtalk-desktop/xc_dingtalk_update/linux_deb/Release/com.alibabainc.dingtalk_8.1.0.6021101_amd64.deb" -O $download_src
	sudo dpkg -i "$download_src"
	sudo patchelf --clear-execstack "$release_dir/dingtalk_dll.so"
fi


# Building Bin
touch /tmp/dingtalk-bin
cat > /tmp/dingtalk-bin <<'EOF'
#!/usr/bin/env bash
export QT_QPA_PLATFORM="wayland;xcb"
export QT_AUTO_SCREEN_SCALE_FACTOR=1
cd /opt/apps/com.alibabainc.dingtalk/files/8.1.0-Release.6021101
./com.alibabainc.dingtalk
EOF
sudo cp /tmp/dingtalk-bin /usr/bin/dingtalk-bin
sudo chmod +x /usr/bin/dingtalk-bin


# Wrinting Desktop File
touch /tmp/com.alibabainc.dingtalk.desktop
cat > /tmp/com.alibabainc.dingtalk.desktop <<'EOF'
[Desktop Entry]
Categories=Chat;Office;
Comment=
Exec=/usr/bin/dingtalk-bin
GenericName=dingtalk
Icon=/opt/apps/com.alibabainc.dingtalk/files/logo.ico
Keywords=dingtalk;
MimeType=x-scheme-handler/dingtalk;
Name=Dingtalk
Type=Application
X-Deepin-Vendor=user-custom
EOF
sudo cp /tmp/com.alibabainc.dingtalk.desktop $desktop_file
