#!/usr/bin/env bash

appimage_url="https://github.com/azahar-emu/azahar/releases/download/2125.0.1/azahar.AppImage"
appimage_dir="/usr/local/opt/azahar"
icon_url="https://raw.githubusercontent.com/azahar-emu/azahar/refs/heads/master/dist/azahar.png"

sudo mkdir -p $appimage_dir
if [ ! -e "$appimage_dir/azahar.AppImage" ]; then
  wget "$appimage_url" -O /tmp/azahar.AppImage
  sudo cp --verbose /tmp/azahar.AppImage "$appimage_dir/azahar.AppImage"
fi
sudo chmod +x "$appimage_dir/azahar.AppImage"
sudo ln -sf "$appimage_dir/azahar.AppImage" /usr/local/bin/azahar

# Desktop file
touch /tmp/Azahar.desktop
cat > /tmp/Azahar.desktop <<'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Azahar
GenericName=3DS Emulator
GenericName[fr]=Émulateur 3DS
Comment=Nintendo 3DS video game console emulator
Comment[fr]=Émulateur de console de jeu Nintendo 3DS
Icon=org.azahar_emu.Azahar
TryExec=azahar
Exec=azahar %f
Categories=Game;Emulator;
MimeType=application/x-ctr-3dsx;application/x-ctr-cci;application/x-ctr-cia;application/x-ctr-cxi;
Keywords=3DS;Nintendo;
EOF
sudo cp --verbose /tmp/Azahar.desktop /usr/local/share/applications/Azahar.desktop

# Icon File
if [ ! -e "/tmp/org.azahar_emu.Azahar.png" ]; then
  wget "$icon_url" -O /tmp/org.azahar_emu.Azahar.png
fi
sudo cp --verbose /tmp/org.azahar_emu.Azahar.png /usr/local/share/icons/hicolor/128x128/apps/org.azahar_emu.Azahar.png
sudo gtk-update-icon-cache -f -t /usr/local/share/icons/hicolor
