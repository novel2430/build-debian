#!/usr/bin/env bash

pkg_name="lutris"
pkg_version="0.5.22"
pkg_mode="tracked"
pkg_type="artifact"
track_backend="deb-apt"

DEB_URL="https://github.com/lutris/lutris/releases/download/v$pkg_version/lutris_${pkg_version}_all.deb"

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

  track_query_cmd="dpkg -s $(printf '%q' "$track_package_name")"
  track_remove_cmd="dpkg -r $(printf '%q' "$track_package_name")"
  track_install_cmd="apt install -y $(printf '%q' "$deb")"

  export track_package_name track_package_version
  export track_query_cmd track_remove_cmd track_install_cmd

  al_run_with_optional_sudo apt install -y "$deb" || return 1
}
