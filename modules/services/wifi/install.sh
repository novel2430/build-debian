#!/usr/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

sudo cp --verbose /etc/network/interfaces /etc/network/interfaces.bak
sudo cp --verbose /etc/NetworkManager/NetworkManager.conf /etc/NetworkManager/NetworkManager.conf.bak

sudo cp --verbose "$SCRIPT_DIR/interfaces" /etc/network/interfaces
sudo cp --verbose "$SCRIPT_DIR/NetworkManager.conf" /etc/NetworkManager/NetworkManager.conf

sudo rc-service networking stop
sudo rc-update del networking

sudo rc-service network-manager stop
sudo rc-service network-manager start
sudo rc-update add network-manager default
