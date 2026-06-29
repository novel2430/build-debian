pkg_name="alacritty"
pkg_version="0.17.0"
pkg_mode="managed"
pkg_type="source"

stage_acquire() {
  al_require_recipe_cmd cargo
  al_require_recipe_cmd rustup

  al_git_checkout_repo \
    "https://github.com/alacritty/alacritty.git" \
    "$WORKDIR/$pkg_name" \
    v"$pkg_version"
}

stage_prepare() {
  SRCDIR="$WORKDIR/$pkg_name"
  BUILDDIR="$SRCDIR"
  export SRCDIR BUILDDIR
}

stage_configure() {
  (
    cd "$SRCDIR" || exit 1

    # v0 pragmatic choice:
    # keep toolchain selection here instead of inventing a separate toolchain stage
    rustup default stable || exit 1

  ) || return 1
}

stage_build() {
  (
    cd "$SRCDIR" || exit 1

    # cargo clean || exit 1
    cargo build --release -j8 || exit 1
  ) || return 1
}

stage_stage() {
  al_stage_install_file "$SRCDIR/target/release/alacritty" "bin/alacritty" 755 || return 1

  local libdir="lib/x86_64-linux-gnu"
  al_stage_install_file "$SRCDIR/target/release/libalacritty_config_derive.so" "$libdir/libalacritty_config_derive.so" 755 || return 1

  al_stage_install_icon \
    "$SRCDIR/extra/logo/compat/alacritty-term.png" \
    "128x128" \
    "Alacritty" \
    "png" || return 1

  al_stage_write_desktop_entry "Alacritty" <<'EOF'
[Desktop Entry]
Type=Application
TryExec=alacritty
Exec=alacritty
Icon=Alacritty
Terminal=false
Categories=System;TerminalEmulator;

Name=Alacritty
GenericName=Terminal
Comment=A fast, cross-platform, OpenGL terminal emulator
StartupNotify=true
StartupWMClass=Alacritty
Actions=New;
EOF
}
