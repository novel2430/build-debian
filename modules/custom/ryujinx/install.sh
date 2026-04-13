#!/usr/bin/env bash

appimage_url="https://legacy.git.ryujinx.app/api/v4/projects/1/packages/generic/Ryubing/1.3.3/ryujinx-1.3.3-x64.AppImage"
appimage_dir="/usr/local/opt/ryujinx"
icon_url="https://raw.githubusercontent.com/Ryubing/Assets/refs/heads/main/RyujinxApp_1024.png"

sudo mkdir -p $appimage_dir
if [ ! -e "$appimage_dir/ryujinx.AppImage" ]; then
  wget "$appimage_url" -O /tmp/ryujinx.AppImage
  sudo cp --verbose /tmp/ryujinx.AppImage "$appimage_dir/ryujinx.AppImage"
fi
sudo chmod +x "$appimage_dir/ryujinx.AppImage"
sudo ln -sf "$appimage_dir/ryujinx.AppImage" /usr/local/bin/ryujinx

# Desktop file
touch /tmp/Ryujinx.desktop
cat > /tmp/Ryujinx.desktop <<'EOF'
[Desktop Entry]
Version=1.0
Name=Ryujinx
Type=Application
Icon=ryujinx
Exec=ryujinx %f
Comment=A Nintendo Switch Emulator
GenericName=Nintendo Switch Emulator
Terminal=false
Categories=Game;Emulator;
MimeType=application/x-nx-nca;application/x-nx-nro;application/x-nx-nso;application/x-nx-nsp;application/x-nx-xci;
Keywords=Switch;Nintendo;Emulator;
StartupWMClass=ryujinx
PrefersNonDefaultGPU=true
EOF
sudo cp --verbose /tmp/Ryujinx.desktop /usr/local/share/applications/Ryujinx.desktop

# Icon File
if [ ! -e "/usr/local/share/icons/hicolor/128x128/apps/Ryujinx.png" ]; then
  wget "$icon_url" -O /tmp/Ryujinx.png
  sudo cp --verbose /tmp/Ryujinx.png /usr/local/share/icons/hicolor/128x128/apps/Ryujinx.png
  sudo cp --verbose /tmp/Ryujinx.png /usr/local/share/icons/hicolor/128x128/apps/ryujinx.png
fi
