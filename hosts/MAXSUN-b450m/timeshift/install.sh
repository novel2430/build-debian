#!/usr/bin/env bash
CUR_DIR="$(cd "$(dirname "$0")" && pwd)"

sudo cp --verbose $CUR_DIR/timeshift.json /etc/timeshift/timeshift.json
sudo cp --verbose $CUR_DIR/timeshift-auto@.service /etc/systemd/system/timeshift-auto@.service
sudo cp --verbose $CUR_DIR/timeshift-auto@weekly.timer /etc/systemd/system/timeshift-auto@weekly.timer
