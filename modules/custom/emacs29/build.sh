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
