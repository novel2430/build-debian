#!/usr/bin/env bash

appimage_url="https://github.com/hrydgard/ppsspp/releases/download/v1.20.3/PPSSPP-v1.20.3-anylinux-x86_64.AppImage"
appimage_dir="/usr/local/opt/PPSSPP"
icon_url="https://upload.wikimedia.org/wikipedia/commons/thumb/d/dc/PPSSPP_logo.svg/960px-PPSSPP_logo.svg.png"

sudo mkdir -p $appimage_dir
if [ ! -e "$appimage_dir/PPSSPP.AppImage" ]; then
  wget "$appimage_url" -O /tmp/PPSSPP.AppImage
  sudo cp --verbose /tmp/PPSSPP.AppImage "$appimage_dir/PPSSPP.AppImage"
fi
sudo chmod +x "$appimage_dir/PPSSPP.AppImage"
sudo ln -sf "$appimage_dir/PPSSPP.AppImage" /usr/local/bin/ppsspp

# Desktop file
touch /tmp/org.ppsspp.PPSSPP.desktop
cat > /tmp/org.ppsspp.PPSSPP.desktop <<'EOF'
[Desktop Entry]
Version=1.0
Name=PPSSPPSDL
Exec=ppsspp
Icon=PPSSPPSDL
Type=Application
Comment=PPSSPP (fast and portable PSP emulator)
Keywords=Sony;PlayStation;Portable;PSP;handheld;console;
Categories=Game;Emulator;
StartupWMClass=PPSSPPSDL
EOF
sudo cp --verbose /tmp/org.ppsspp.PPSSPP.desktop /usr/local/share/applications/PPSSPPSDL.desktop

# Icon File
if [ ! -e "/tmp/org.ppsspp.PPSSPP.png" ]; then
  wget "$icon_url" -O /tmp/org.ppsspp.PPSSPP.png
fi
sudo cp --verbose /tmp/org.ppsspp.PPSSPP.png /usr/local/share/icons/hicolor/128x128/apps/PPSSPPSDL.png
sudo gtk-update-icon-cache -f -t /usr/local/share/icons/hicolor
