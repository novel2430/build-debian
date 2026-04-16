#!/usr/bin/env bash

CUR_DIR="$(cd "$(dirname "$0")" && pwd)"
AIRLOCK_BIN_DIR="$CUR_DIR/../../airlock/bin/airlock"

airlock_install() {
  if $AIRLOCK_BIN_DIR info "$1" > /dev/null 2>&1; then
    echo "[$1] Already Installed"
  else
    $AIRLOCK_BIN_DIR install "$1"
  fi
}

airlock_install 'latex-chinese-fonts'
