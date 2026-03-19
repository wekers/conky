#!/usr/bin/env bash

# --------------------------------------------------
# Conky Installer (Portable / Resilient / Multi-distro)
# By Fernando Gilli fernando<at>wekers(dot)org
# Last modified:2026-03-19                  
# --------------------------------------------------

set -u  # evita variáveis não definidas (sem quebrar o script)

echo "[Conky] Preparing environment..."

# --------------------------------------------------
# Detect OS
# --------------------------------------------------

OS_ID="unknown"

if [ -f /etc/os-release ]; then
  . /etc/os-release
  OS_ID=$ID
fi

# --------------------------------------------------
# Helper: safe command
# --------------------------------------------------

safe_run() {
  "$@" || {
    echo "[Conky] Warning: command failed → $*"
    return 0
  }
}

# --------------------------------------------------
# Install Debian / Ubuntu / Mint
# --------------------------------------------------

install_debian() {
  echo "[Conky] Detected Debian/Ubuntu/Mint"

  echo "[Conky] Updating package lists..."
  if ! sudo apt update; then
    echo "[Conky] Warning: apt update failed (continuing anyway)"
  fi

  # Detect correct Conky package
  if apt-cache show conky-all >/dev/null 2>&1; then
    CONKY_PKG="conky-all"
  else
    CONKY_PKG="conky"
  fi

  echo "[Conky] Installing dependencies..."

  safe_run sudo apt install -y \
    "$CONKY_PKG" \
    curl \
    bc \
    libxml2-utils \
    lm-sensors \
    imagemagick \
    perl \
    jq \
    cpanminus

  # --------------------------------------------------
  # Install Perl module (Moon phase)
  # --------------------------------------------------

  if ! perl -MAstro::MoonPhase -e1 2>/dev/null; then
    echo "[Conky] Installing Astro::MoonPhase..."

    if command -v cpanm >/dev/null; then
      safe_run sudo cpanm Astro::MoonPhase
    else
      safe_run sudo cpan -T -i Astro::MoonPhase
    fi
  else
    echo "[Conky] Astro::MoonPhase already installed"
  fi
}

# --------------------------------------------------
# Fedora / RHEL
# --------------------------------------------------

install_fedora() {
  echo "[Conky] Detected Fedora/RHEL"

  safe_run sudo dnf install -y \
    conky \
    curl \
    bc \
    libxml2 \
    lm_sensors \
    ImageMagick \
    perl \
    jq \
    perl-App-cpanminus

  if ! perl -MAstro::MoonPhase -e1 2>/dev/null; then
    safe_run sudo cpanm Astro::MoonPhase
  fi
}

# --------------------------------------------------
# Arch Linux
# --------------------------------------------------

install_arch() {
  echo "[Conky] Detected Arch Linux"

  safe_run sudo pacman -Sy --noconfirm \
    conky \
    curl \
    bc \
    libxml2 \
    lm_sensors \
    imagemagick \
    perl \
    jq \
    cpanminus

  if ! perl -MAstro::MoonPhase -e1 2>/dev/null; then
    safe_run sudo cpanm Astro::MoonPhase
  fi
}

# --------------------------------------------------
# Slackware (manual)
# --------------------------------------------------

install_slackware() {
  echo "[Conky] Slackware detected"
  echo "[Conky] Please install dependencies manually:"
  echo "  - conky"
  echo "  - curl"
  echo "  - bc"
  echo "  - libxml2 (xmllint)"
  echo "  - lm_sensors"
  echo "  - ImageMagick"
  echo "  - perl + Astro::MoonPhase"
}

# --------------------------------------------------
# Dispatcher
# --------------------------------------------------

case "$OS_ID" in
  ubuntu|debian|linuxmint)
    install_debian
    ;;
  fedora|rhel|centos)
    install_fedora
    ;;
  arch)
    install_arch
    ;;
  slackware)
    install_slackware
    ;;
  *)
    echo "[Conky] Unknown distribution: $OS_ID"
    echo "[Conky] Please install dependencies manually."
    ;;
esac

# --------------------------------------------------
# Fix permissions
# --------------------------------------------------

echo "[Conky] Setting executable permissions..."
chmod +x ./*.sh 2>/dev/null || true

# --------------------------------------------------
# Create directories
# --------------------------------------------------

mkdir -p "$HOME/.config/conky"
mkdir -p "$HOME/.cache"

# --------------------------------------------------
# Done
# --------------------------------------------------

echo "[Conky] Done."
echo ""
echo "Next steps:"
echo "  1. Configure API key:"
echo "     nano ~/.config/conky/secrets.conf"
echo ""
echo "  2. Run Conky:"
echo "     ./conky.sh"