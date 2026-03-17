#!/usr/bin/env bash

download_src="/tmp/com.alibabainc.dingtalk_8.1.0.6021101_amd64.deb"
desktop_file="/usr/share/applications/com.alibabainc.dingtalk.desktop"

sudo rm -rf /usr/bin/dingtalk-bin
sudo rm -rf $desktop_file
sudo rm -rf $download_src
sudo dpkg -r com.alibabainc.dingtalk
