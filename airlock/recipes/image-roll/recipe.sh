#!/usr/bin/env bash

pkg_name="image-roll"
pkg_version="2.1.0"
pkg_mode="tracked"
pkg_type="artifact"
track_backend="deb-apt"

DEB_URL="https://github.com/weclaw1/image-roll/releases/download/2.1.0/image-roll_2.1.0_amd64.deb"

stage_acquire() {
  al_fetch_url_uncached \
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
