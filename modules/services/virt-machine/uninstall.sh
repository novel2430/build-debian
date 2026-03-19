#!/usr/bin/env bash
set -e

echo "== Stopping libvirt service =="
sudo systemctl stop libvirtd
sudo systemctl disable libvirtd

echo "== Removing default libvirt network =="
sudo virsh net-destroy default 2>/dev/null || true
sudo virsh net-undefine default 2>/dev/null || true

echo "== Removing QEMU/KVM and virt-manager packages =="
sudo apt remove --purge -y \
  qemu-kvm \
  libvirt-daemon-system \
  libvirt-clients \
  bridge-utils \
  virt-manager \
  virtinst

echo "== Auto-removing dependencies =="
sudo apt autoremove -y

echo "== Optional: Remove user from libvirt/kvm groups =="
echo "You can run the following commands manually if desired:"
echo "  sudo gpasswd -d $USER libvirt"
echo "  sudo gpasswd -d $USER kvm"

echo "== Uninstall complete =="
