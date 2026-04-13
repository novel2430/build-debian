#!/usr/bin/env bash

XLIBRE_REPO_DIR="$HOME/src/xlibre-xserver"
XF86_INPUT_REPO_DIR="$HOME/src/xf86-input-libinput"
XLIBRE_PREFIX_DIR="/usr/local/opt/xlibre/"

if [ -e "$XLIBRE_REPO_DIR/build" ]; then
  (
    cd "$XLIBRE_REPO_DIR"
    sudo ninja -C build install
  )
fi

if [ -e "$XF86_INPUT_REPO_DIR" ]; then
  (
    cd "$XF86_INPUT_REPO_DIR"
    export PKG_CONFIG_PATH="$XLIBRE_PREFIX_DIR/lib/x86_64-linux-gnu/pkgconfig/"
    rm -rf build
    meson setup build --prefix="$XLIBRE_PREFIX_DIR"
    ninja -C build
    sudo ninja -C build install
  )
fi

if [ ! -e "$HOME/.local/bin/xlibre-run" ]; then
cat > "$HOME/.local/bin/xlibre-run" <<'EOF'
#!/usr/bin/env bash
if [ -e "/usr/local/opt/xlibre/bin/X" ]; then
  startx -- /usr/local/opt/xlibre/bin/X vt1
fi
EOF
chmod +x "$HOME/.local/bin/xlibre-run"
fi

cat > "/tmp/99-swcursor.conf" <<'EOF'
Section "Device"
  Identifier "modesetting"
  Option "SWCursor" "true"
EndSection
EOF
sudo cp --verbose "/tmp/99-swcursor.conf" "$XLIBRE_PREFIX_DIR/share/X11/xorg.conf.d/99-swcursor.conf"
