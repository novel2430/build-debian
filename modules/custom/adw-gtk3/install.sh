#!/usr/bin/env bash

src_url="https://github.com/lassekongo83/adw-gtk3/releases/download/v6.4/adw-gtk3v6.4.tar.xz"
src_file="/tmp/adw-gtk3.tar.xz"
src_dir="/tmp/adw-gtk3-src"
install_dir="$HOME/.local/share/theme"

if [ ! -e $src_file ]; then
  wget "$src_url" -O $src_file
  mkdir -p $src_dir
  tar -xJvf $src_file -C $src_dir
fi

if [ ! -e $install_dir/adw-gtk3 ]; then
  mkdir -p $install_dir
  cp -r $src_dir/* $install_dir
fi
