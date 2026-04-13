#!/usr/bin/env bash

pkg_name="spotify"
pkg_version="1.2.86.502"
pkg_mode="tracked"
pkg_type="artifact"
track_backend="deb-apt"

DEB_URL="http://repository.spotify.com/pool/non-free/s/spotify-client/spotify-client_1.2.86.502.g8cd7fb22_amd64.deb"

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
