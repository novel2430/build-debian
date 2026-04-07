#!/usr/bin/env bash

KERNEL_VERSION="6.19.11"
KERNEL_URL="https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-$KERNEL_VERSION.tar.xz"
ZEN_PATCH_URL="https://github.com/zen-kernel/zen-kernel/releases/download/v$KERNEL_VERSION-zen1/linux-v$KERNEL_VERSION-zen1.patch.zst"

KERNEL_DOWN_DIR="/tmp/linux-$KERNEL_VERSION.tar.xz"
ZEN_PATCH_DOWN_DIR="/tmp/linux-v$KERNEL_VERSION-zen1.patch.zst"
KERNEL_SRC_DIR="$HOME/src/linux-$KERNEL_VERSION"
ZEN_PATCH_SRC_DIR="$KERNEL_SRC_DIR/linux-v$KERNEL_VERSION-zen1.patch.zst"

if [ ! -e "$KERNEL_DOWN_DIR" ]; then
  wget "$KERNEL_URL" -O "$KERNEL_DOWN_DIR"
fi

if [ ! -e "$ZEN_PATCH_DOWN_DIR" ]; then
  wget "$ZEN_PATCH_URL" -O "$ZEN_PATCH_DOWN_DIR"
fi


if [ ! -e "$KERNEL_SRC_DIR" ]; then
  mkdir -p $HOME/src
  tar -xvf "$KERNEL_DOWN_DIR" -C $HOME/src
  if [ ! -e "$ZEN_PATCH_SRC_DIR" ]; then
    unzstd "$ZEN_PATCH_DOWN_DIR" -o "$ZEN_PATCH_SRC_DIR"
  fi
fi


if [ ! -e "/boot/vmlinuz-$KERNEL_VERSION-zen1-custom" ]; then
  (
    set -euo pipefail
    # Patch
    cd "$KERNEL_SRC_DIR"
    if patch --dry-run -p1 < "$ZEN_PATCH_SRC_DIR" >/dev/null 2>&1; then
      patch -p1 < "$ZEN_PATCH_SRC_DIR"
    else
      exit 1
    fi
    make clean
    # Config
    cp /boot/config-$(uname -r) .config
    make olddefconfig
    # localversion
    echo "-custom" > localversion
    make -s kernelrelease
    # compile
    make -j8
  )
fi
