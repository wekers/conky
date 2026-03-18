#!/usr/bin/env bash

# --------------------------------------------------
# Conky Weather Initialization Script
# --------------------------------------------------

CONFIG_DIR="$HOME/.config/conky"
CACHE_DIR="$HOME/.cache"
SECRETS_FILE="$CONFIG_DIR/secrets.conf"

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
OWM_CITY=joinville,br
EOF

  chmod 600 "$SECRETS_FILE"

  echo "[Conky] Please edit the file and insert your API key:"
  echo "         nano $SECRETS_FILE"
  exit 1
fi

# Load secrets
# shellcheck disable=SC1090
. "$SECRETS_FILE"

# --------------------------------------------------
# Validate variables
# --------------------------------------------------

if [ -z "$OWM_APPID" ] || [ "$OWM_APPID" = "YOUR_API_KEY_HERE" ]; then
  echo "[Conky] Invalid or missing OWM_APPID in $SECRETS_FILE"
  exit 1
fi

if [ -z "$OWM_CITY" ]; then
  echo "[Conky] Missing OWM_CITY in $SECRETS_FILE"
  exit 1
fi

# Check for xmllint
if ! command -v xmllint >/dev/null; then
  echo "[Conky] Missing xmllint (install libxml2-utils)"
  exit 1
fi

# --------------------------------------------------
# Fetch weather data
# --------------------------------------------------

echo "[Conky] Fetching weather for: $OWM_CITY"

# Current weather
curl -s "https://api.openweathermap.org/data/2.5/weather?q=${OWM_CITY}&units=metric&lang=pt&mode=xml&appid=${OWM_APPID}" \
  | xmllint --format - > "$CACHE_DIR/weather_current.xml"

# Forecast
curl -s "https://api.openweathermap.org/data/2.5/forecast?q=${OWM_CITY}&units=metric&lang=pt&mode=xml&appid=${OWM_APPID}" \
  | xmllint --format - > "$CACHE_DIR/weather.xml"

# --------------------------------------------------
# Validate output
# --------------------------------------------------

if grep -q "<current>" "$CACHE_DIR/weather_current.xml" 2>/dev/null; then
  echo "[Conky] Weather cache initialized successfully."
else
  echo "[Conky] Failed to fetch weather data."
  echo "[Conky] Tip: Use format City,CountryCode (e.g., Joinville,BR)"
  echo "[Conky] Check your API key and internet connection."
  exit 1
fi

exit 0