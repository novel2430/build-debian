#!/usr/bin/env bash

set -e

echo "== Checking CPU virtualization support =="
VIRT_SUPPORT=$(egrep -c '(vmx|svm)' /proc/cpuinfo || true)
if [ "$VIRT_SUPPORT" -eq 0 ]; then
    echo "ERROR: Your CPU does not support hardware virtualization (VT-x / AMD-V)."
    echo "QEMU/KVM cannot be used. Exiting."
    exit 1
else
    echo "CPU supports hardware virtualization. Proceeding..."
fi

FLAG_FILE="$HOME/.qemu-virt-installed"
if [ -f "$FLAG_FILE" ]; then
    echo "QEMU/KVM + virt-manager installation already done. Exiting."
    exit 0
fi

echo "== Installing QEMU, KVM, libvirt and virt-manager =="
sudo apt install -y \
  qemu-kvm \
  libvirt-daemon-system \
  libvirt-clients \
  bridge-utils \
  virt-manager \
  virtinst

echo "== Enable and start libvirt =="
# sudo systemctl enable --now libvirtd
sudo rc-service libvirtd start
sudo rc-update add libvirtd default

echo "== Ensure default network is active =="
sudo virsh net-start default 2>/dev/null || true
sudo virsh net-autostart default 2>/dev/null || true

echo "== Adding current user to libvirt and kvm groups =="
sudo usermod -aG libvirt,kvm "$USER"

echo "== Done =="
echo "Please LOGOUT/LOGIN or REBOOT to activate group changes."
echo "After reboot, you can start virt-manager with: virt-manager"
touch "$FLAG_FILE"
