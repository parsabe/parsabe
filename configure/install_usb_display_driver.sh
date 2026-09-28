#!/usr/bin/env bash
set -e

echo "========================================================"
echo "Installing MacroSilicon MS9133 USB-to-HDMI Display Driver"
echo "========================================================"

if [ "$EUID" -ne 0 ]; then
  echo "Please run this script with sudo:"
  echo "  sudo bash $0"
  exit 1
fi

SRC_DIR="/home/hounaar/ms91xx-linux-drm"
DKMS_DEST="/usr/src/msdisp-3.0.3.13"

echo "[1/4] Copying driver source to $DKMS_DEST..."
mkdir -p "$DKMS_DEST"
rsync -a --exclude .git --exclude "*.ko" --exclude "*.o" "$SRC_DIR/" "$DKMS_DEST/"

echo "[2/4] Registering with DKMS..."
dkms remove msdisp/3.0.3.13 --all 2>/dev/null || true
dkms add msdisp/3.0.3.13

echo "[3/4] Building and installing DKMS module for kernel $(uname -r)..."
dkms install msdisp/3.0.3.13

echo "[4/4] Loading kernel modules..."
modprobe usbdisp_drm 2>/dev/null || insmod "$SRC_DIR/drm/usbdisp_drm.ko" 2>/dev/null || true
modprobe usbdisp_usb 2>/dev/null || insmod "$SRC_DIR/drm/usbdisp_usb.ko" 2>/dev/null || true

echo ""
echo "========================================================"
echo "Installation complete!"
echo "If your adapter is plugged in, unplug it and plug it back in."
echo "Check GNOME Settings -> Displays or run: xrandr --listmonitors"
echo "========================================================"
