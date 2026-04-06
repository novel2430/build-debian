#!/usr/bin/env bash
flatpak override --user cn.wps.wps_365 --filesystem=$HOME/WechatData
flatpak override --user cn.wps.wps_365 --filesystem=$HOME/Documents
flatpak override --user cn.wps.wps_365 --filesystem=$HOME/Pictures
flatpak override --user cn.wps.wps_365 --filesystem=$HOME/Downloads
flatpak override --user cn.wps.wps_365 --filesystem=$HOME/.tmp
