#!/usr/bin/env bash
set -e

echo "Setting MUTTER_DEBUG_DISABLE_HW_CURSORS=1..."

# 1. User environment
mkdir -p "$HOME/.config/environment.d"
echo "MUTTER_DEBUG_DISABLE_HW_CURSORS=1" > "$HOME/.config/environment.d/mutter.conf"

# 2. System environment (requires sudo)
if [ "$EUID" -eq 0 ]; then
  if ! grep -q "MUTTER_DEBUG_DISABLE_HW_CURSORS" /etc/environment; then
    echo "MUTTER_DEBUG_DISABLE_HW_CURSORS=1" >> /etc/environment
  fi
  echo "Successfully added to /etc/environment!"
else
  echo "Run with sudo to add to /etc/environment as well:"
  echo "  sudo bash $0"
fi

echo ""
echo "Done! Please log out of your GNOME session and log back in (or reboot) for the change to take effect."
