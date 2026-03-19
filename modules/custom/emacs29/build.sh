#!/usr/bin/env bash

src_url="https://ftp.gnu.org/gnu/emacs/emacs-29.4.tar.xz"
file_dir="/tmp/emacs-29.4.tar.xz"
src_dir="$HOME/src/emacs-29.4"

if [ ! -e "$file_dir" ]; then
  wget $src_url -O $file_dir
fi

if [ ! -e "$src_dir" ]; then
  tar -xvf $file_dir -C $HOME/src
fi

sudo apt install -y \
  build-essential \
  pkg-config \
  texinfo \
  make \
  autoconf \
  automake \
  libtool \
  git \
  wget \
  curl \
  xz-utils \
  gperf \
  python3 \
  python3-pip \
  libncurses-dev \
  libgtk-3-dev \
  libx11-dev \
  libxaw7-dev \
  libxpm-dev \
  libxrandr-dev \
  libxi-dev \
  libotf-dev \
  libm17n-dev \
  libgnutls28-dev \
  libharfbuzz-dev \
  libxml2-dev \
  libgif-dev \
  libjpeg-dev \
  libpng-dev \
  librsvg2-dev \
  libtiff-dev \
  libwebkit2gtk-4.1-dev \
  libglib2.0-dev \
  libsqlite3-dev \
  libselinux1-dev \
  libdbus-1-dev \
  mailutils \
  ca-certificates

if [ -e "$src_dir" ]; then
  (
    cd "$src_dir"
    ./configure \
      --without-build-details \
      --with-modules \
      --with-x \
      --with-x-toolkit=gtk3 \
      --with-cairo \
      --with-xinput2 \
      --without-pgtk \
      --with-xwidgets \
      --with-compress-install \
      --with-toolkit-scroll-bars \
      --with-native-compilation=no \
      --with-mailutils \
      --with-tree-sitter \
      --with-sqlite3 \
      --with-dbus \
      --with-selinux \
      --prefix=/usr/local && \
      make clean && make -j4
  )
fi
