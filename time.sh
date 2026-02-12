#!/bin/bash
# -------------------------------------------------------------------
# File: time.sh
# Type: Bash Shell Script
# Author: Fernando Gilli
# Last modified: 2026-02-12
# -------------------------------------------------------------------
# Weather and Moon data manipulation for Conky
# Compatible with Linux / FreeBSD
# -------------------------------------------------------------------

lang="pt-br"

DirShell="$HOME/.conky/wekers"
CACHE_CURRENT="$HOME/.cache/weather_current.xml"
CACHE_FORECAST="$HOME/.cache/weather.xml"
MOON_FILE="$DirShell/moon_phase_die"

# -------------------------------------------------------
# Helper Functions
# -------------------------------------------------------

# Extract first matching line from current weather XML
xml_current() {
    grep -m1 "$1" "$CACHE_CURRENT"
}


# Extract forecast block by datetime
xml_forecast_block() {
    local datetime="$1"
    grep -A6 "from=\"$datetime\"" "$CACHE_FORECAST"
}

# Get forecast temperature (min/max)
get_forecast_temp() {
    local datetime="$1"
    local field="$2"
    xml_forecast_block "$datetime" \
        | sed -n 7p \
        | cut -d'"' -f"$field" \
        | cut -d'.' -f1
}

# Extract forecast symbol line
get_forecast_symbol() {
    local datetime="$1"
    xml_forecast_block "$datetime" | sed -n 2p
}

# -------------------------------------------------------
# Forecast helpers (refactored)
# -------------------------------------------------------

# Get forecast block by day offset (1,2,3)
forecast_block() {
    local day="$1"
    local time
    time=$(date --date="$day day" +%Y-%m-%dT12:00:00)

    awk -v t="$time" '
        $0 ~ "from=\""t"\"" {getline; print; exit}
    ' "$CACHE_FORECAST"
}

# Extract forecast description (cast text)
forecast_cast() {
    local day="$1"
    local time
    time=$(date --date="$day day" +%Y-%m-%dT12:00:00)

    awk -v t="$time" '
        $0 ~ "from=\""t"\"" {
            while (getline) {
                if ($0 ~ /symbol number=/) {
                    match($0, /name="([^"]+)"/, arr)
                    if (arr[1] != "") {
                        print arr[1]
                        exit
                    }
                }
                if ($0 ~ /<\/time>/) exit
            }
        }
    ' "$CACHE_FORECAST" \
    | cut -d'.' -f1 \
    | awk '{print toupper(substr($0,1,1)) substr($0,2)}'
}


# -------------------------------------------------------
# Language block
# -------------------------------------------------------

case "$lang" in
    pt-br)
        cpre="--> "
        cprec="Possib. Chuva"
        rain="--> Chuva"
        prox="Próx"
        on="em"
        mm="mm"
        feels="Sensação Térmica"
        cloud_text="Cobertura de Nuvens"

        windv=$(xml_current "speed" | cut -d'"' -f6 | sed \
            -e 's/Light breeze/Brisa Leve/g' \
            -e 's/Moderate breeze/Brisa Moderada/g' \
            -e 's/Fresh Breeze/Brisa Fresca/g' \
            -e 's/Gentle Breeze/Brisa Suave/g' \
            -e 's/Strong breeze/Brisa Forte/g' \
            -e 's/Calm/Brisa Calma/g' \
            -e 's/High wind, near gale/Vento Forte, vendaval perto/g')
        ;;
    *)
        cpre="--> "
        cprec="Chance of Precipitation"
        rain="--> Rain"
        prox="Next"
        on="in"
        mm="mm"
        feels="Feels Like"
        cloud_text="Cloud Cover"
        windv=$(xml_current "speed" | cut -d'"' -f6)
        ;;
esac

# -------------------------------------------------------
# Main Dispatcher
# -------------------------------------------------------

case "$1" in

    # Weather icon logic:
    # - For codes 800–803 (clear / few clouds), OpenWeatherMap icon attribute
    #   provides the correct visual representation (01d, 02n, 03d, 04n).
    # - For all other conditions, numeric weather code maps directly to icons.
    img)
	img_code=$(xml_current "number" | cut -d'"' -f2)
	icon_code=$(xml_current "icon" | cut -d'"' -f6)

	if [[ "$img_code" =~ ^80[0-3]$ ]]; then
	    # clear / few clouds → use icon attribute (01d, 02n, 03d, 04n…)
	    cp -f "${DirShell}/images/${icon_code}.png" ~/.cache/weather.png
	else
	    # other conditions, numeric code
	    cp -f "${DirShell}/images/${img_code}.png" ~/.cache/weather.png
	fi
	;;


    dir)
	result=$(xml_current "direction" | awk -F'"' 'NF>=4 {print $4}' | tr '[:lower:]' '[:upper:]')

	if [ -n "$result" ]; then
	  echo "$result"
	fi
	;;

    wname)
        speed=$(xml_current "speed" | awk -F'"' 'NF>=2 {print $2}')
        name=$(xml_current "speed" | awk -F'"' 'NF>=6 {print $6}')

        # If wind speed is zero or empty → no wind
        if [ -z "$speed" ] || awk "BEGIN {exit !($speed == 0)}" || [ "$speed" = "Setting" ]; then
           
           if [ "$lang" = "pt-br" ]; then
               echo "Sem vento"
           else
               echo "No wind"
           fi
           
        else
          echo "$windv"
        fi
        ;;

    wicon)
	speed=$(xml_current "speed" | cut -d'"' -f2)
	direction=$(xml_current "direction" | awk -F'"' 'NF>=4 {print $4}' | tr '[:upper:]' '[:lower:]')

	if [ "$speed" != "0" ] && [ -n "$direction" ]; then
	  cp -f "$DirShell/images/wind/orange_${direction}.png" ~/.cache/wind.png
	fi
	;;


    1max|2max|3max)
        day="${1%max}"
        time=$(date --date="$day day" +%Y-%m-%dT15:00:00)
        get_forecast_temp "$time" 8
        ;;

    1min|2min|3min)
        day="${1%min}"
        time=$(date --date="$day day" +%Y-%m-%dT06:00:00)
        get_forecast_temp "$time" 6
        ;;

    weather-1|weather-2|weather-3)
        day="${1#weather-}"
        block=$(forecast_block "$day")
        code=$(echo "$block" | awk -F'"' '{print $2}')

        if [[ "$code" =~ ^80[0-3]$ ]]; then
            code=$(echo "$block" | awk -F'"' '{print $6}')
        fi

        cp -f "$DirShell/images/${code}.png" ~/.cache/weather-${day}.png
        ;;

    cast-1|cast-2|cast-3)
        day="${1#cast-}"
        forecast_cast "$day"
        ;;

    # -------------------------------------------------------
    # Moon next events (safe version)
    # -------------------------------------------------------

    mnext)
        line3=$(sed -n '3p' "$MOON_FILE")
        line4=$(sed -n '4p' "$MOON_FILE")

        if [ -n "$line3" ] && [ -n "$line4" ]; then
            echo "   $prox $line3 --> $line4"
        fi
        ;;

    mnextfull)
        line1=$(sed -n '1p' "$MOON_FILE")
        line2=$(sed -n '2p' "$MOON_FILE")

        if [ -n "$line1" ] && [ -n "$line2" ]; then
            echo "   $prox $line1 --> $line2"
        fi
        ;;

    # -------------------------------------------------------
    # Apparent temperature (Heat Index style)
    # -------------------------------------------------------

    at)
        temper=$(xml_current "temperature" | cut -d'"' -f2)
        wspeed=$(xml_current "speed" | cut -d'"' -f2)
        rh=$(xml_current "humidity" | cut -d'"' -f2)

        rhcalc=$(echo "$rh/100" | bc -l)
        exp=$(echo "(17.27*$temper)/(237.7+$temper)" | bc -l)
        ex=$(echo "e($exp*l(6.105))" | bc -l)
        e=$(echo "$rhcalc*$ex" | bc -l)
        at=$(echo "$temper + (0.348*$e) - (0.7*$wspeed) - 4" | bc -l)

        if [ -n "$at" ]; then
	  awk 'BEGIN{printf "%d\n", '"$at"'+0.5}'
	fi
        ;;

    temp)
        xml_current "temperature" | cut -d'"' -f2 | awk '{printf "%d\n",$1+0.5}'
        ;;

    clouds)
        xml_current "clouds" | cut -d'"' -f2
        ;;

    cloudtext)
        echo "$cloud_text"
        ;;

    atext)
        echo "$feels"
        ;;
        
    lastupdate)
	raw=$(xmllint --xpath 'string(//lastupdate/@value)' ~/.cache/weather_current.xml 2>/dev/null)
	date -d "$raw UTC" +"%H:%M"
	;;



    # -------------------------------------------------------
    # Precipitation (fully refactored)
    # -------------------------------------------------------

    precipitation)

        hora=$(date +%H%M)
        hora=$((10#$hora))

        chuva=$(xml_current "precipitation" | cut -d'"' -f2)

        # If currently raining
        if [[ "$chuva" != "no" ]]; then
            echo " $rain $chuva $mm"
            exit 0
        fi

        # Calculate next 3-hour forecast slot
        hour_now=$(date +%H)
        hour_now=$((10#$hour_now))
        next_slot=$(( ( (hour_now / 3) + 1 ) * 3 ))


        if (( next_slot >= 24 )); then
            time=$(date --date="1 day" +%Y-%m-%dT00:00:00)
        else
            printf -v next_slot "%02d" "$next_slot"
            time=$(date +%Y-%m-%dT${next_slot}:00:00)
        fi

        block=$(grep -A5 "from=\"$time\"" "$CACHE_FORECAST")
        probability=$(echo "$block" | sed -n 3p | cut -d'"' -f2)
        result=$(echo "$block" | sed -n 3p | cut -d'"' -f6)

        if [[ "$result" == "<precipitation/>" || "$probability" == "0" ]]; then
            exit 0
        fi

        result=$(echo "$result" | awk '{printf "%0.2f\n",$1}')

        if [[ "$result" == "0.00" ]]; then
            exit 0
        fi

        probability=$(echo "$probability * 100" | bc | awk '{printf "%0.0f\n",$1}')

        echo " $cpre${probability}% $cprec $result $mm"
        ;;

    *)
        ;;
esac

exit 0

# EOF
