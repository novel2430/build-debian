#!/usr/bin/env bash

set -euo pipefail

sudo rm -rf /usr/local/bin/wezterm
sudo rm -rf /usr/local/bin/wezterm-gui
sudo rm -rf /usr/local/bin/wezterm-mux-server
sudo rm -rf /usr/local/lib/x86_64-linux-gnu/libwezterm_config_derive.so
sudo rm -rf /usr/local/lib/x86_64-linux-gnu/libwezterm_dynamic_derive.so
sudo ldconfig
sudo rm -rf /usr/local/share/icons/hicolor/scalable/apps/wezterm.svg
sudo rm -rf /usr/local/share/icons/hicolor/128x128/apps/wezterm.png
sudo rm -rf /usr/local/share/applications/wezterm.desktop
