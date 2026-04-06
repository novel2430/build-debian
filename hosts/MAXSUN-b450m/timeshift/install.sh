#!/usr/bin/env bash
CUR_DIR="$(cd "$(dirname "$0")" && pwd)"

sudo mkdir -p /etc/timeshift

sudo cp --verbose "$CUR_DIR/timeshift-backup.sh" /usr/bin/my-timeshift-backup

sudo cp --verbose "$CUR_DIR/timeshift.json" /etc/timeshift/default.json

sudo chmod +x /usr/bin/my-timeshift-backup

