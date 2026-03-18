#!/usr/bin/env bash

echo "[Conky] Preparing environment..."

# Fix script permissions
find . -name "*.sh" -exec chmod +x {} \;

echo "[Conky] Installing dependencies..."

if command -v apt >/dev/null; then
  echo "[Conky] Detected Debian/Ubuntu"
  sudo apt update
  sudo apt install -y conky curl libxml2-utils perl lm-sensors

elif command -v dnf >/dev/null; then
  echo "[Conky] Detected Fedora"
  sudo dnf install -y conky curl libxml2 perl lm_sensors

elif command -v yum >/dev/null; then
  echo "[Conky] Detected CentOS/RHEL"
  sudo yum install -y conky curl libxml2 perl lm_sensors

elif command -v zypper >/dev/null; then
  echo "[Conky] Detected openSUSE"
  sudo zypper install -y conky curl libxml2-tools perl lm_sensors

elif command -v pacman >/dev/null; then
  echo "[Conky] Detected Arch"
  sudo pacman -S --noconfirm conky curl libxml2 perl lm_sensors

else
  echo "[Conky] Unsupported distro."
  echo "Please install manually:"
  echo "  - conky"
  echo "  - curl"
  echo "  - xmllint"
  echo "  - perl"
  echo "  - lm-sensors"
fi

echo "[Conky] Done." 
