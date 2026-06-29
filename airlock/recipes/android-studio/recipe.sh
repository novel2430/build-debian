# Example recipe for a source-based package.
#
# This recipe demonstrates the minimal v0 metadata and per-stage overrides.

pkg_name="android-studio"
pkg_version="2026.1.1.10"
pkg_mode="managed"
pkg_type="artifact"


stage_acquire() {
  al_fetch_cached_url \
    "https://dl.google.com/dl/android/studio/ide-zips/${pkg_version}/android-studio-quail1-patch2-linux.tar.gz" \
    "$WORKDIR/$pkg_name/$pkg_version.tar.gz"
}

stage_prepare() {
  al_extract_archive_for_recipe \
    "$WORKDIR/$pkg_name/$pkg_version.tar.gz" \
    "$WORKDIR/$pkg_name"

  SRCDIR="$WORKDIR/$pkg_name"
  BUILDDIR="$SRCDIR"
  export SRCDIR BUILDDIR
}

stage_stage() {
  local optdir="opt/$pkg_name"
  mkdir -p "$STAGE_DIR$PREFIX/$optdir"
  mkdir -p "$STAGE_DIR$PREFIX/bin"
  cp -a $SRCDIR/$pkg_name/{bin,lib,jbr,plugins,license,LICENSE.txt,build.txt,product-info.json} "$STAGE_DIR$PREFIX/$optdir"
  al_stage_install_cmd_wrapper "$pkg_name" "$optdir/bin/studio"
  al_stage_install_icon "$SRCDIR/$pkg_name/bin/studio.png" "128x128" "$pkg_name" "png"
  al_stage_write_desktop_entry "$pkg_name" <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Android Studio
Icon=$pkg_name
Exec=$pkg_name %f
Comment=Android Studio
Categories=Development;IDE;
Terminal=false
EOF
}
