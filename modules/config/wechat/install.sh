#!/usr/bin/env bash
mkdir -p $HOME/WechatData
flatpak override --user com.tencent.WeChat --filesystem=$HOME/WechatData
flatpak override --user com.tencent.WeChat --filesystem=$HOME/Documents
flatpak override --user com.tencent.WeChat --filesystem=$HOME/Pictures
flatpak override --user com.tencent.WeChat --filesystem=$HOME/Downloads
