# Example recipe for a source-based package.
#
# This recipe demonstrates the minimal v0 metadata and per-stage overrides.

pkg_name="kernel-cachyos-bore-stable"
pkg_version="6.19"
pkg_mode="managed"
pkg_type="source"

MINOR_VER=12
VER=2
SRCNAME="cachyos-${pkg_version}.${MINOR_VER}-${VER}"

stage_acquire() {
  al_fetch_cached_url \
    "https://github.com/CachyOS/linux/releases/download/${SRCNAME}/${SRCNAME}.tar.gz" \
    "$WORKDIR/$pkg_name/$pkg_version.tar.gz"

  al_fetch_cached_url \
    "https://raw.githubusercontent.com/cachyos/kernel-patches/master/${pkg_version}/sched/0001-bore-cachy.patch" \
    "$WORKDIR/$pkg_name/0001-bore-cachy.patch"
}

stage_prepare() {
  al_extract_archive_for_recipe \
    "$WORKDIR/$pkg_name/$pkg_version.tar.gz" \
    "$WORKDIR/$pkg_name"

  SRCDIR="$WORKDIR/$pkg_name/$SRCNAME"
  BUILDDIR="$SRCDIR/build"
  PATCH_DIR="$WORKDIR/$pkg_name/0001-bore-cachy.patch"

  export SRCDIR BUILDDIR PATCH_DIR
}

stage_configure() {
  (
    cd "$SRCDIR"
    if patch --dry-run -p1 < "$PATCH_DIR" >/dev/null 2>&1; then
      patch -p1 < "$PATCH_DIR"
    else
      exit 1
    fi
    make clean
    cp /boot/config-$(uname -r) .config || exit 1
    ./scripts/config -e SCHED_BORE || exit 1
    ./scripts/config -d HZ_300 -e HZ_1000 --set-val HZ 1000 || exit 1
    ./scripts/config -d HZ_PERIODIC -d NO_HZ_FULL -e NO_HZ_IDLE -e NO_HZ -e NO_HZ_COMMON || exit 1
    ./scripts/config -d PREEMPT_DYNAMIC -e PREEMPT -d PREEMPT_LAZY || exit 1
    ./scripts/config -d TRANSPARENT_HUGEPAGE_ALWAYS -e TRANSPARENT_HUGEPAGE_MADVISE || exit 1
    # Close
    ./scripts/config -e LTO_NONE || exit 1
    ./scripts/config -d ARCH_SUPPORTS_CFI_CLANG -d CFI_CLANG -d CFI_AUTO_DEFAULT || exit 1
    ./scripts/config -d CC_OPTIMIZE_FOR_PERFORMANCE_O3 -e CC_OPTIMIZE_FOR_PERFORMANCE || exit 1
    ./scripts/config -d CPU_FREQ_DEFAULT_GOV_PERFORMANCE -e CPU_FREQ_DEFAULT_GOV_SCHEDUTIL || exit 1
    ./scripts/config -d DEFAULT_BBR -e DEFAULT_CUBIC --set-str DEFAULT_TCP_CONG cubic || exit 1
    make olddefconfig || exit 1
  )
}

stage_build() {
  (
    cd "$SRCDIR"
    echo "-cachyos-bore" > localversion
    make -s kernelrelease
    make -j10
  )
}

stage_stage() {
  (
    cd "$SRCDIR" || exit 1

    krel="$(make -s kernelrelease)" || exit 1
    bootdir="$STAGE_DIR/boot"

    mkdir -p "$bootdir" || exit 1

    make INSTALL_MOD_PATH="$STAGE_DIR" modules_install || exit 1

    cp -f --verbose arch/x86/boot/bzImage "$bootdir/vmlinuz-$krel" || exit 1
    cp -f --verbose System.map "$bootdir/System.map-$krel" || exit 1
    cp -f --verbose .config "$bootdir/config-$krel" || exit 1
  )
}
