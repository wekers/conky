#!/usr/bin/env bash

# Ensure the script runs with bash even if invoked via "sh"
[ -z "$BASH_VERSION" ] && exec bash "$0" "$@"

# Resolve script directory (portable, independent of execution path)
DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR" || exit 1

# Initialize weather cache (safe for first run)
bash "$DIR/init.sh" || echo "[Conky] Skipping weather initialization"

# Prevent multiple Conky instances
if pgrep -x conky >/dev/null; then
  echo "Conky is already running."
  exit 0
fi

# --------------------------------------------------
# Detect screen resolution (Wayland + X11 compatible)
# --------------------------------------------------

# Try to get resolution from the PRIMARY monitor (preferred method)
RES=$(xrandr 2>/dev/null | awk '/ primary/ {print $4}' | sed 's/+.*//')

# Fallback: get the highest resolution from connected monitors
if [ -z "$RES" ]; then
  RES=$(xrandr 2>/dev/null | awk '/ connected/ {print $3}' | sed 's/+.*//' | sort -nr | head -n1)
fi

# Final fallback (safe default)
[ -z "$RES" ] && RES="2560x1440"

# Extract screen width
WIDTH=$(echo "$RES" | cut -d'x' -f1)

# --------------------------------------------------
# Select configuration automatically
# --------------------------------------------------

if [ "$WIDTH" -ge 2560 ]; then
  CONFIG="$DIR/conkyrc/.conkyrc_2k"
else
  CONFIG="$DIR/conkyrc/.conkyrc_1080p"
fi

echo "Detected resolution: $RES"
echo "Starting Conky with config: $CONFIG"

# --------------------------------------------------
# Start Conky
# --------------------------------------------------

conky -c "$CONFIG" &

exit 0