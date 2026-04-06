#!/usr/bin/env bash
app_name="org.mozilla.firefox"
flatpak override --user "$app_name" --filesystem=$HOME/WechatData
flatpak override --user "$app_name" --filesystem=$HOME/Documents
flatpak override --user "$app_name" --filesystem=$HOME/Pictures
flatpak override --user "$app_name" --filesystem=$HOME/Downloads
flatpak override --user "$app_name" --filesystem=$HOME/.tmp
