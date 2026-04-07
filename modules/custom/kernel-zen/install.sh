#!/usr/bin/env bash

KERNEL_VERSION="6.19.11"
KERNEL_SRC_DIR="$HOME/src/linux-$KERNEL_VERSION"

if [ -e "$KERNEL_SRC_DIR" ]; then
  (
    set -euo pipefail
    cd "$KERNEL_SRC_DIR"
    sudo make modules_install
    sudo make install
    sudo update-initramfs -c -k "$(make -s kernelrelease)"
    sudo update-grub
  )
fi
