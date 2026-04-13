#!/usr/bin/env bash

pkg_name="baidunetdisk"
pkg_version="4.17.8"
pkg_mode="tracked"
pkg_type="artifact"
track_backend="deb-apt"

DEB_URL="http://wppkg.baidupcs.com/issue/netdisk/Linuxguanjia/$pkg_version/baidunetdisk_${pkg_version}_amd64.deb"

stage_acquire() {
  mkdir -p "$WORKDIR/$pkg_name" || return 1

  al_fetch_url \
    "$DEB_URL" \
    "$WORKDIR/$pkg_name/$pkg_version.deb"
}

stage_prepare() {
  track_source_url="$DEB_URL"
  track_source_file="$WORKDIR/$pkg_name/$pkg_version.deb"

  export track_source_url track_source_file
}

track_install() {
  local deb="$track_source_file"
  local custom_bin="/usr/local/bin/baidunetdisk"
  local desktop_dir="/usr/share/applications/baidunetdisk.desktop"

  al_tracked_install_deb_with_apt "$deb" || return 1

  # Keep the custom wrapper cleanup behavior on remove.
  track_remove_cmd="$track_remove_cmd; rm -rf $(printf '%q' "$custom_bin")"
  export track_remove_cmd

  # Building Bin
  touch "/tmp/$pkg_name" 
  cat > "/tmp/$pkg_name" <<'EOF'
#!/usr/bin/env bash
cd /opt/baidunetdisk
GDK_BACKEND=x11 HOME="${HOME:-/tmp}/.local/share/baidu" ./baidunetdisk "$@"
EOF
  sudo cp "/tmp/$pkg_name" "$custom_bin"
  sudo chmod +x "$custom_bin"

  # Wrinting Desktop File
  touch "/tmp/$pkg_name.desktop"
  cat > "/tmp/$pkg_name.desktop" <<'EOF'
[Desktop Entry]
Name=Baidu Netdisk
Name[zh_CN]=百度网盘
Name[zh_TW]=百度网盘
Exec=/usr/local/bin/baidunetdisk --no-sandbox %U
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
  sudo cp "/tmp/$pkg_name.desktop" "$desktop_dir"
}
