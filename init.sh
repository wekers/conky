#!/usr/bin/env bash
# --------------------------------------------------
# Conky Weather Initialization Script
# --------------------------------------------------

set -e

CONFIG_DIR="$HOME/.config/conky"
CACHE_DIR="$HOME/.cache"
SECRETS_FILE="$CONFIG_DIR/secrets.conf"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

mkdir -p "$CONFIG_DIR" "$CACHE_DIR"

echo "[Conky] Initializing weather cache..."

# --------------------------------------------------
# Check secrets file
# --------------------------------------------------
if [ ! -f "$SECRETS_FILE" ]; then
  echo "[Conky] Missing secrets file: $SECRETS_FILE"
  echo "[Conky] Creating example..."

  cat > "$SECRETS_FILE" <<EOF
# OpenWeatherMap configuration
OWM_APPID=YOUR_API_KEY_HERE
OWM_CITY=Joinville,BR
EOF

  chmod 600 "$SECRETS_FILE"

  echo "[Conky] Please edit the file and insert your API key:"
  echo "         nano $SECRETS_FILE"

  exit 2
fi

# --------------------------------------------------
# Load secrets
# --------------------------------------------------
# shellcheck disable=SC1090
. "$SECRETS_FILE"

# --------------------------------------------------
# Validate variables
# --------------------------------------------------
if [ -z "$OWM_APPID" ] || [ "$OWM_APPID" = "YOUR_API_KEY_HERE" ]; then
  echo "[Conky] Weather not configured yet (missing API key)"
  exit 2
fi

if [ -z "$OWM_CITY" ]; then
  echo "[Conky] Missing OWM_CITY in $SECRETS_FILE"
  exit 2
fi

# --------------------------------------------------
# Check dependencies
# --------------------------------------------------
if ! command -v xmllint >/dev/null; then
  echo "[Conky] Missing xmllint (install libxml2-utils)"
  exit 1
fi

if ! command -v curl >/dev/null; then
  echo "[Conky] Missing curl"
  exit 1
fi

# --------------------------------------------------
# Fetch weather data safely
# --------------------------------------------------
echo "[Conky] Fetching weather for: $OWM_CITY"

CURRENT_DATA=$(curl -s "https://api.openweathermap.org/data/2.5/weather?q=${OWM_CITY}&units=metric&lang=pt&mode=xml&appid=${OWM_APPID}")
FORECAST_DATA=$(curl -s "https://api.openweathermap.org/data/2.5/forecast?q=${OWM_CITY}&units=metric&lang=pt&mode=xml&appid=${OWM_APPID}")

if echo "$CURRENT_DATA" | grep -q "<current>"; then
  echo "$CURRENT_DATA" | xmllint --format - > "$CACHE_DIR/weather_current.xml"
else
  echo "[Conky] Failed to fetch current weather data."
  echo "[Conky] Tip: Use City,CountryCode (e.g., Joinville,BR)"
  exit 1
fi

if echo "$FORECAST_DATA" | grep -q "<weatherdata>"; then
  echo "$FORECAST_DATA" | xmllint --format - > "$CACHE_DIR/weather.xml"
else
  echo "[Conky] Failed to fetch forecast data."
  exit 1
fi

echo "[Conky] Weather XML cache initialized successfully."

# --------------------------------------------------
# Generate initial assets
# --------------------------------------------------
echo "[Conky] Generating initial weather assets..."

for cmd in img weather-1 weather-2 weather-3; do
  bash "$SCRIPT_DIR/time.sh" "$cmd" 2>/dev/null || true
done

# Moon (optional)
bash "$SCRIPT_DIR/GetMoon.sh" >/dev/null 2>&1 || true

# --------------------------------------------------
# Final check
# --------------------------------------------------
if [ -f "$CACHE_DIR/weather.png" ]; then
  echo "[Conky] Initialization completed successfully."
else
  echo "[Conky] Warning: weather images not generated yet."
fi

exit 0