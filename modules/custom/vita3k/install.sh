#!/usr/bin/env bash

appimage_url="https://github.com/Vita3K/Vita3K/releases/download/continuous/Vita3K-x86_64.AppImage"
appimage_dir="/usr/local/opt/Vita3K"
icon_url="https://github.com/Vita3K/Vita3K/blob/master/data/image/icon.png?raw=true"

sudo mkdir -p $appimage_dir
if [ ! -e "$appimage_dir/Vita3K.AppImage" ]; then
  wget "$appimage_url" -O /tmp/Vita3K.AppImage
  sudo cp --verbose /tmp/Vita3K.AppImage "$appimage_dir/Vita3K.AppImage"
fi
sudo chmod +x "$appimage_dir/Vita3K.AppImage"
sudo ln -sf "$appimage_dir/Vita3K.AppImage" /usr/local/bin/vita3k

# Desktop file
touch /tmp/Vita3K.desktop
cat > /tmp/Vita3K.desktop <<'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Vita3K
GenericName=PSV Emulator
Exec=vita3k
Icon=vita3k
StartupWMClass=Vita3K
Categories=Game;Emulator;
EOF
sudo cp --verbose /tmp/Vita3K.desktop /usr/local/share/applications/Vita3K.desktop

# Icon File
if [ ! -e "/tmp/Vita3K.png" ]; then
  wget "$icon_url" -O /tmp/Vita3K.png
fi
sudo cp --verbose /tmp/Vita3K.png /usr/local/share/icons/hicolor/128x128/apps/vita3k.png
sudo gtk-update-icon-cache -f -t /usr/local/share/icons/hicolor
