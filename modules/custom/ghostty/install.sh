#!/usr/bin/env bash

set -euo pipefail

target_dir="$HOME/src/ghostty/zig-out"

if [[ -d "$target_dir" ]]; then
  sudo mkdir -p /usr/local/opt/ghostty
  sudo cp -r --verbose $target_dir/* /usr/local/opt/ghostty/

  # Icon
  ICON_DIR="/usr/local/opt/ghostty/share/icons/hicolor"
  DST_DIR="/usr/local/share/icons/hicolor"
  find "$ICON_DIR" -type f -name "*.png" | while read SRC_FILE; do
    REL_PATH="${SRC_FILE#$ICON_DIR/}"
    DST_FILE="$DST_DIR/$REL_PATH"
    sudo mkdir -p "$(dirname "$DST_FILE")"
    sudo ln -sf "$SRC_FILE" "$DST_FILE"
  done
fi

# Binary File
touch /tmp/ghostty
cat > /tmp/ghostty <<'EOF'
#!/usr/bin/env bash
if [ -n "$GHOSTTY_USE_SOFTWARE_RENDER" ]; then
  export LIBGL_ALWAYS_SOFTWARE=true
fi
exec /usr/local/opt/ghostty/bin/ghostty "$@"
EOF
sudo cp --verbose /tmp/ghostty /usr/local/bin/ghostty
sudo chmod +x /usr/local/bin/ghostty

# Desktop File
touch /tmp/com.mitchellh.ghostty.desktop
cat > /tmp/com.mitchellh.ghostty.desktop <<'EOF'
[Desktop Entry]
Version=1.0
Name=Ghostty
Type=Application
Comment=A terminal emulator
TryExec=/usr/local/bin/ghostty
Exec=/usr/local/bin/ghostty --gtk-single-instance=true
Icon=com.mitchellh.ghostty
Categories=System;TerminalEmulator;
Keywords=terminal;tty;pty;
StartupNotify=true
StartupWMClass=com.mitchellh.ghostty
Terminal=false
Actions=new-window;
X-GNOME-UsesNotifications=true
X-TerminalArgExec=-e
X-TerminalArgTitle=--title=
X-TerminalArgAppId=--class=
X-TerminalArgDir=--working-directory=
X-TerminalArgHold=--wait-after-command
DBusActivatable=true
X-KDE-Shortcuts=Ctrl+Alt+T

[Desktop Action new-window]
Name=New Window
Exec=/usr/local/bin/ghostty --gtk-single-instance=true
EOF
sudo cp --verbose /tmp/com.mitchellh.ghostty.desktop /usr/local/share/applications/com.mitchellh.ghostty.desktop
