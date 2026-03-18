#!/usr/bin/env bash

# Ensure bash even if called with sh
[ -z "$BASH_VERSION" ] && exec bash "$0" "$@"

# Resolve script directory
DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR" || exit 1

sleep 1

# Prevent multiple instances
if pgrep -x conky >/dev/null; then
  echo "[Conky] Already running."
  exit 0
fi

# --------------------------------------------------
# Initialize weather (with exit handling)
# --------------------------------------------------
bash "$DIR/init.sh"
STATUS=$?

if [ "$STATUS" -eq 2 ]; then
  echo "[Conky] Weather disabled (not configured)"
elif [ "$STATUS" -ne 0 ]; then
  echo "[Conky] Weather initialization failed"
fi

# --------------------------------------------------
# Detect resolution (Wayland + X11)
# --------------------------------------------------
RES=$(xrandr 2>/dev/null | awk '/ primary/ {print $4}' | sed 's/+.*//')

if [ -z "$RES" ]; then
  RES=$(xrandr 2>/dev/null | awk '/ connected/ {print $3}' | sed 's/+.*//' | sort -nr | head -n1)
fi

[ -z "$RES" ] && RES="2560x1440"

WIDTH=$(echo "$RES" | cut -d'x' -f1)

# --------------------------------------------------
# Select config
# --------------------------------------------------
if [ "$WIDTH" -ge 2560 ]; then
  CONFIG="$DIR/conkyrc/.conkyrc_2k"
else
  CONFIG="$DIR/conkyrc/.conkyrc_1080p"
fi

echo "[Conky] Detected resolution: $RES"
echo "[Conky] Starting with config: $CONFIG"

# --------------------------------------------------
# Start Conky
# --------------------------------------------------
conky -c "$CONFIG" &

exit 0