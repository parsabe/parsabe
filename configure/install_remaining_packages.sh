#!/usr/bin/env bash
set -e

echo "=========================================="
echo "Installing Packages & NVIDIA AI Drivers"
echo "=========================================="

if [ "$EUID" -ne 0 ]; then
  echo "Please run this script with sudo:"
  echo "  sudo bash $0"
  exit 1
fi

echo "[1/4] Updating package repositories..."
apt-get update

echo "[2/4] Installing ffmpeg, gpick, and winff..."
apt-get install -y ffmpeg gpick winff

echo "[3/4] Ensuring full LaTeX support (XeTeX & extra packages)..."
apt-get install -y texlive-xetex texlive-science

echo "[4/4] Installing NVIDIA Drivers for RTX 4060 & DKMS..."
apt-get install -y linux-headers-"$(uname -r)" nvidia-driver nvidia-kernel-dkms

echo ""
echo "=========================================="
echo "Installation complete!"
echo "NOTE: Please reboot your system to load the NVIDIA drivers:"
echo "  sudo reboot"
echo "After reboot, test your GPU with: nvidia-smi"
echo "=========================================="
