#!/usr/bin/env bash

pkg_name="smoke-managed"
pkg_version="1.0.0"
pkg_mode="managed"
pkg_type="artifact"

stage_acquire() {
  local src_root="$WORKDIR/$pkg_name"

  mkdir -p "$src_root/docs" || return 1

  cat > "$src_root/smoke-bin" <<'SCRIPT'
#!/usr/bin/env bash
printf 'smoke-managed-ok\n'
SCRIPT
  chmod 755 "$src_root/smoke-bin" || return 1

  printf 'smoke docs\n' > "$src_root/docs/readme.txt" || return 1

  cat > "$src_root/icon.svg" <<'SVG'
<svg xmlns="http://www.w3.org/2000/svg" width="64" height="64" viewBox="0 0 64 64">
  <rect width="64" height="64" rx="8" fill="#1f8f5f"/>
  <text x="32" y="38" text-anchor="middle" font-size="22" fill="#ffffff">S</text>
</svg>
SVG
}

stage_prepare() {
  SRCDIR="$WORKDIR/$pkg_name"
  BUILDDIR="$SRCDIR"
  export SRCDIR BUILDDIR
}

stage_stage() {
  al_stage_install_file "$SRCDIR/smoke-bin" "libexec/smoke-managed/smoke-bin" 755
  al_stage_install_cmd_wrapper "smoke-managed" "libexec/smoke-managed/smoke-bin"
  al_stage_install_dir "$SRCDIR/docs" "share/smoke-managed/docs" 644
  al_stage_install_icon "$SRCDIR/icon.svg" "scalable" "smoke-managed" "svg"

  al_stage_write_desktop_entry "smoke-managed" <<'DESKTOP'
[Desktop Entry]
Version=1.0
Type=Application
Name=Smoke Managed
Exec=smoke-managed
Icon=smoke-managed
Categories=Utility;
DESKTOP
}
