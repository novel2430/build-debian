#!/usr/bin/env bash

src_url="https://cdn.openttd.org/openttd-releases/15.2/openttd-15.2-linux-generic-amd64.tar.xz"
tmp_dir="/tmp/openttd.tar.xz"
target_dir="$HOME/.local/opt/openttd"

mkdir -p $target_dir

rm -rf $tmp_dir
wget $src_url -O $tmp_dir 

if [ ! -e "$target_dir/openttd" ]; then
  tar -xvf $tmp_dir -C /tmp 
  cp -r /tmp/openttd-15.2-linux-generic-amd64/* $target_dir

  # Desktop File
  ln -sf "$target_dir/share/applications/openttd.desktop" "$HOME/.local/share/applications/openttd.desktop"

  # Icon
  ICON_DIR="$target_dir/share/icons/hicolor"
  DST_DIR="$HOME/.local/share/icons/hicolor"
  find "$ICON_DIR" -type f -name "*.png" | while read SRC_FILE; do
    REL_PATH="${SRC_FILE#$ICON_DIR/}"
    DST_FILE="$DST_DIR/$REL_PATH"
    mkdir -p "$(dirname "$DST_FILE")"
    ln -sf "$SRC_FILE" "$DST_FILE"
  done
fi

cat > $HOME/.local/bin/openttd <<'EOF'
#!/usr/bin/env bash
cd "$HOME/.local/opt/openttd"
exec ./openttd "$@"
EOF
chmod +x $HOME/.local/bin/openttd
