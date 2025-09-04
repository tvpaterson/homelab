#!/bin/bash

# Exit on any error
set -e

# Check if script is run with sudo
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root or with sudo."
  exit 1
fi

# Update & upgrade system
echo "Updating and upgrading the system..."
apt-get update
apt-get upgrade -y

# Install required dependencies
echo "Installing required dependencies..."
apt-get install -y curl wget git


ufw disable

# Disable swap
echo "Disabling swap..."
swapoff -a
# Comment out swap entries in /etc/fstab
if grep -v '^#' /etc/fstab | grep -q swap; then
  sed -i '/swap/s/^/#/' /etc/fstab
  echo "Swap disabled in /etc/fstab."
else
  echo "No swap entries found in /etc/fstab."
fi

# Step 6: Enable cgroups (required for some systems like Raspberry Pi)
echo "Ensuring cgroups are enabled..."
if [ -f /boot/firmware/cmdline.txt ]; then
  if ! grep -q "cgroup_memory=1 cgroup_enable=memory" /boot/firmware/cmdline.txt; then
    echo "Adding cgroup parameters to /boot/firmware/cmdline.txt..."
    sed -i '$ s/$/ cgroup_memory=1 cgroup_enable=memory/' /boot/firmware/cmdline.txt
    echo "cgroup parameters added. Reboot required."
  else
    echo "cgroup parameters already set in /boot/firmware/cmdline.txt."
  fi
elif [ -f /boot/cmdline.txt ]; then
  if ! grep -q "cgroup_memory=1 cgroup_enable=memory" /boot/cmdline.txt; then
    echo "Adding cgroup parameters to /boot/cmdline.txt..."
    sed -i '$ s/$/ cgroup_memory=1 cgroup_enable=memory/' /boot/cmdline.txt
    echo "cgroup parameters added. Reboot required."
  else
    echo "cgroup parameters already set in /boot/cmdline.txt."
  fi
else
  echo "No /boot/firmware/cmdline.txt or /boot/cmdline.txt found. Assuming cgroups are enabled (standard for Ubuntu)."
fi

echo "Setup complete. Please reboot and run the relevant K3s script (worker or master)"


NODE_TOKEN = K10df077d37c040860dd611004f468c063c4f614a29cfe00cb84e633cfdd79c532e::server:cf218deabbedd443c9cab3537b433373

curl -sfL https://get.k3s.io | K3S_TOKEN="K10df077d37c040860dd611004f468c063c4f614a29cfe00cb84e633cfdd79c532e::server:cf218deabbedd443c9cab3537b433373" K3S_URL="https://192.168.0.146:6443" INSTALL_K3S_NAME="workerpi2" sh -