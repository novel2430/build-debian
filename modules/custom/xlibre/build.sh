#!/usr/bin/env bash

XLIBRE_REPO_URL="https://github.com/X11Libre/xserver.git"
XF86_INPUT_REPO_URL="https://gitlab.freedesktop.org/xorg/driver/xf86-input-libinput.git"

XLIBRE_REPO_DIR="$HOME/src/xlibre-xserver"
XF86_INPUT_REPO_DIR="$HOME/src/xf86-input-libinput"

XLIBRE_PREFIX_DIR="/usr/local/opt/xlibre/"

if [ ! -e "$XLIBRE_REPO_DIR" ]; then
  git clone "$XLIBRE_REPO_URL" "$XLIBRE_REPO_DIR"
fi

if [ ! -e "$XF86_INPUT_REPO_DIR" ]; then
  git clone "$XF86_INPUT_REPO_URL" "$XF86_INPUT_REPO_DIR"
fi

if [ -e "$XLIBRE_REPO_DIR" ]; then
  (
    cd "$XLIBRE_REPO_DIR"
    git checkout 'xlibre-xserver-25.1.3'
    rm -rf build
    meson setup build --prefix="$XLIBRE_PREFIX_DIR" \
      -D ipv6=true \
      -D xvfb=true \
      -D xnest=true \
      -D xcsecurity=true \
      -D xorg=true \
      -Ddri3=true \
      -Dglx_dri=true \
      -D xephyr=true \
      -D xfbdev=true \
      -D glamor=true \
      -D udev=true \
      -D dtrace=false \
      -D systemd_logind=false \
      -D seatd_libseat=true \
      -D suid_wrapper=true \
      -D linux_acpi=false \
      -D legacy_nvidia_padding=true \
      -D legacy_nvidia_340x=true \
      -D suid_wrapper=true \
      -D xkb_dir='/usr/share/X11/xkb' \
      -D xkb_output_dir='/var/lib/xkb' \
      -D libunwind=true
    ninja -C build
  )
fi

