# Example recipe for a source-based package.
#
# This recipe demonstrates the minimal v0 metadata and per-stage overrides.

pkg_name="river"
pkg_version="0.3.14"
pkg_mode="managed"
pkg_type="source"

stage_acquire() {
  al_git_checkout_repo \
    "https://codeberg.org/river/river-classic.git" \
    "$WORKDIR/$pkg_name" \
    v"$pkg_version"
}

stage_prepare() {
  SRCDIR="$WORKDIR/$pkg_name"
  BUILDDIR="$SRCDIR/build"
  export SRCDIR BUILDDIR
}

stage_build() {
  (
    cd "$SRCDIR"
    unset http_proxy
    unset https_proxy
    zig build -Doptimize=ReleaseFast 
  )
}

stage_stage() {
  mkdir -p "$STAGE_DIR$PREFIX" || exit 1
  cp -r --verbose $SRCDIR/zig-out/* "$STAGE_DIR$PREFIX"
}
