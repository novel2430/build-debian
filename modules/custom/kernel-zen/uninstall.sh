#!/usr/bin/env bash

KERNEL_VERSION="6.19.11"
KERNEL_SRC_DIR="$HOME/src/linux-$KERNEL_VERSION"
RUNNING="$(uname -r)"

if [ -e "$KERNEL_SRC_DIR" ]; then
  (
    set -euo pipefail
    cd "$KERNEL_SRC_DIR"
    KVER="$(make -s kernelrelease)"
    if [ "$KVER" = "$RUNNING" ]; then
      echo "[error] Connot delete running kernel: $KVER"
      exit 1
    fi
    if [ -e "/lib/modules/$KVER" ]; then
      sudo rm -rv -- "/lib/modules/$KVER"
    fi
    if [ -e "/boot/vmlinuz-$KVER" ]; then
      sudo rm -rv -- "/boot/vmlinuz-$KVER"
    fi
    if [ -e "/boot/initrd.img-$KVER" ]; then
      sudo rm -rv -- "/boot/initrd.img-$KVER"
    fi
    if [ -e "/boot/System.map-$KVER" ]; then
      sudo rm -rv -- "/boot/System.map-$KVER"
    fi
    sudo update-grub
  )
fi
