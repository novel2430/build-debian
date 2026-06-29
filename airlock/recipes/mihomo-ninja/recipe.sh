#!/usr/bin/env bash

pkg_name="mihomo-ninja"
pkg_version="df9c14c"
pkg_mode="managed"
pkg_type="artifact"

stage_acquire() {
  al_fetch_cached_url \
    "https://github.com/kachetong1314/mihomo-ninja/releases/download/$pkg_version/ninja-linux-amd64" \
    "$WORKDIR/$pkg_name/ninja-linux-amd64"
}

stage_prepare() {
  SRCDIR="$WORKDIR/$pkg_name"
  BUILDDIR="$SRCDIR"
  export SRCDIR BUILDDIR
}

stage_stage() {
  al_stage_install_file "$SRCDIR/ninja-linux-amd64" "bin/mihomo-ninja"
}
