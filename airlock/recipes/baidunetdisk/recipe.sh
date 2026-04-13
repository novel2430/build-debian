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


  [ -f "$deb" ] || al_die "Downloaded .deb not found: $deb"

  track_package_name="$(dpkg-deb -f "$deb" Package)" || return 1
  track_package_version="$(dpkg-deb -f "$deb" Version)" || return 1

  local cutom_bin="/usr/local/bin/baidunetdisk"
  local desktop_dir="/usr/share/applications/baidunetdisk.desktop"

  track_query_cmd="dpkg -s $(printf '%q' "$track_package_name")"
  track_remove_cmd="dpkg -r $(printf '%q' "$track_package_name"); rm -rf $cutom_bin"
  track_install_cmd="apt install -y $(printf '%q' "$deb")"

  export track_package_name track_package_version
  export track_query_cmd track_remove_cmd track_install_cmd

  al_run_with_optional_sudo apt install -y "$deb" || return 1

  # Building Bin
  touch "/tmp/$pkg_name" 
  cat > "/tmp/$pkg_name" <<'EOF'
#!/usr/bin/env bash
cd /opt/baidunetdisk
GDK_BACKEND=x11 HOME="${HOME:-/tmp}/.local/share/baidu" ./baidunetdisk "$@"
EOF
  sudo cp "/tmp/$pkg_name" "$cutom_bin"
  sudo chmod +x "$cutom_bin"

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
