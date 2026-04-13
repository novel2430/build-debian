#!/usr/bin/env bash

pkg_name="mihomo"
pkg_version="1.19.21"
pkg_mode="tracked"
pkg_type="artifact"
track_backend="deb-apt"

DEB_URL="https://github.com/MetaCubeX/mihomo/releases/download/v$pkg_version/mihomo-linux-amd64-v1-v$pkg_version.deb"

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
  al_tracked_install_deb_with_apt "$track_source_file"
}
