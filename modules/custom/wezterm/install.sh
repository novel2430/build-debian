#!/usr/bin/env bash

set -euo pipefail

target_dir="$HOME/src/wezterm/target/release"
desktop_file="/usr/local/share/applications/wezterm.desktop"

# Clone
if [[ -d "$target_dir" ]]; then
  sudo install -m 755 $target_dir/wezterm /usr/local/bin
  sudo install -m 755 $target_dir/wezterm-gui /usr/local/bin
  sudo install -m 755 $target_dir/wezterm-mux-server /usr/local/bin
  sudo install -m 755 $target_dir/libwezterm_config_derive.so /usr/local/lib/x86_64-linux-gnu
  sudo install -m 755 $target_dir/libwezterm_dynamic_derive.so /usr/local/lib/x86_64-linux-gnu
  sudo ldconfig
  # Icons
  sudo install -m 755 $target_dir/../../assets/icon/wezterm-icon.svg /usr/local/share/icons/hicolor/scalable/apps/wezterm.svg
  sudo install -m 755 $target_dir/../../assets/icon/terminal.png /usr/local/share/icons/hicolor/128x128/apps/wezterm.png
fi

# Desktop File
touch /tmp/wezterm.desktop
cat > /tmp/wezterm.desktop <<'EOF'
[Desktop Entry]
Name=WezTerm
Comment=Wez's Terminal Emulator
Keywords=shell;prompt;command;commandline;cmd;
Icon=wezterm
StartupWMClass=org.wezfurlong.wezterm
TryExec=wezterm
Exec=wezterm
Type=Application
Categories=System;TerminalEmulator;Utility;
Terminal=false
EOF
sudo cp /tmp/wezterm.desktop $desktop_file
