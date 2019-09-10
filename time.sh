#!/bin/bash

# -------------------------------------------------------------------
# File: time.sh                                          /\
# Type: Bash Shell Script                               /_.\
# By Fernando Gilli fernando<at>wekers(dot)org    _,.-'/ `",\'-.,_
# Last modified:2019-09-04                     -~^    /______\`~~-^~:
# ------------------------
# Manipulate data of weather
# / OS : $Linux, $FreeBSD (X Window)
# -------------------------------------------------------------------


case $1 in
      img)
          img_result=$(grep "number" ~/.cache/weather_current.xml | head -n 1 | cut -d'"' -f2)
	    if [[ $img_result != 800 && $img_result != 801 && $img_result != 802 && $img_result != 803 ]]; then
	      cp -f ~/.conky/wekers/images/$(grep "number" ~/.cache/weather_current.xml | head -n 1 | cut -d'"' -f2).png ~/.cache/weather.png
	      echo ""
	      echo ""
	    fi
          ;;
      dir)
          result=$(grep "direction" ~/.cache/weather_current.xml | head -n 1 | cut -d'"' -f4 | tr [[:lower:]] [[:upper:]] | sed -e 's/^[[:space:]]*//g' -e 's/[[:space:]]*\$//g')
	    if [[ $result != "<DIRECTION/>" ]]; then
	      echo "$result"
	    else
	      echo ""
	    fi
	  ;;

      1max)
	  time=$(date --date="1 day" +%Y-%m-%dT15:00:00)
	  result=$(grep -A5 "from=\"$time\"" ~/.cache/weather.xml | sed -n 6p | cut -d'"' -f8 | cut -d'.' -f1)
	  echo "$result"
          ;;
      2max)
	  time=$(date --date="2 day" +%Y-%m-%dT15:00:00)
	  result=$(grep -A5 "from=\"$time\"" ~/.cache/weather.xml | sed -n 6p | cut -d'"' -f8 | cut -d'.' -f1)
	  echo "$result"
          ;; 
      3max)
	  time=$(date --date="3 day" +%Y-%m-%dT15:00:00)
	  result=$(grep -A5 "from=\"$time\"" ~/.cache/weather.xml | sed -n 6p | cut -d'"' -f8 | cut -d'.' -f1)
	  echo "$result"
          ;;
      1min)
	  time=$(date --date="1 day" +%Y-%m-%dT06:00:00)
	  result=$(grep -A5 "from=\"$time\"" ~/.cache/weather.xml | sed -n 6p | cut -d'"' -f6 | cut -d'.' -f1)
	  echo "$result"
          ;;
      2min)
	  time=$(date --date="2 day" +%Y-%m-%dT06:00:00)
	  result=$(grep -A5 "from=\"$time\"" ~/.cache/weather.xml | sed -n 6p | cut -d'"' -f6 | cut -d'.' -f1)
	  echo "$result"
          ;;
      3min)
	  time=$(date --date="3 day" +%Y-%m-%dT06:00:00)
	  result=$(grep -A5 "from=\"$time\"" ~/.cache/weather.xml | sed -n 6p | cut -d'"' -f6 | cut -d'.' -f1)
	  echo "$result"
          ;;
      weather-1)
	  time=$(date --date="1 day" +%Y-%m-%dT09:00:00)
	  result=$(grep -A1 "from=\"$time\"" ~/.cache/weather.xml | sed -n 2p | cut -d'"' -f2)
	    if [[ $result == 800 || $result == 801 || $result == 802 || $result == 803 ]]; then
	      result=$(grep -A1 "from=\"$time\"" ~/.cache/weather.xml | sed -n 2p | cut -d'"' -f6)
	    fi
	  cp -f ~/.conky/wekers/images/$result.png ~/.cache/weather-1.png
          ;;
      weather-2)
	  time=$(date --date="2 day" +%Y-%m-%dT09:00:00)
	  result=$(grep -A1 "from=\"$time\"" ~/.cache/weather.xml | sed -n 2p | cut -d'"' -f2)
	    if [[ $result == 800 || $result == 801 || $result == 802 || $result == 803 ]]; then
	      result=$(grep -A1 "from=\"$time\"" ~/.cache/weather.xml | sed -n 2p | cut -d'"' -f6)
	    fi
	  cp -f ~/.conky/wekers/images/$result.png ~/.cache/weather-2.png
          ;;
      weather-3)
	  time=$(date --date="3 day" +%Y-%m-%dT09:00:00)
	  result=$(grep -A1 "from=\"$time\"" ~/.cache/weather.xml | sed -n 2p | cut -d'"' -f2)
	    if [[ $result == 800 || $result == 801 || $result == 802 || $result == 803 ]]; then
	      result=$(grep -A1 "from=\"$time\"" ~/.cache/weather.xml | sed -n 2p | cut -d'"' -f6)
	    fi
	  cp -f ~/.conky/wekers/images/$result.png ~/.cache/weather-3.png
          ;;
       precipitation)
	    hora=$(date --date="now" +%H%M)
	    hora=10#$hora
	    currenttimeS=$(date --date="now" +%s)
	    currenttime=$(date --date="now" +%Y-%m-%dT%H:%M:%S)
	    chuva=$(grep "precipitation" ~/.cache/weather_current.xml | head -n 1 | cut -d'"' -f2)


	    if [ $chuva == "no" ]; then


	    if (( $hora >= 10#0000 &&  $hora < 10#0300 )); then
	      time=$(date --date="now" +%Y-%m-%dT03:00:00)
	      result=$(grep -A5 "from=\"$time\"" ~/.cache/weather.xml | sed -n 3p | cut -d'"' -f4 | awk '{ print $1 }')
		if [[ $result == "<precipitation/>" ]]; then
		echo ""
		else
		result=$(grep -A5 "from=\"$time\"" ~/.cache/weather.xml | sed -n 3p | cut -d'"' -f4 | awk '{ print $1 }' | awk '{printf "%0.2f\n",$1}')
		echo Possib. Chuva $result mm
		fi

	    elif (( $hora >= 10#0300 && $hora < 10#0600 )); then
	      time=$(date --date="now" +%Y-%m-%dT06:00:00)
	      result=$(grep -A5 "from=\"$time\"" ~/.cache/weather.xml | sed -n 3p | cut -d'"' -f4 | awk '{ print $1 }')
		if [[ $result == "<precipitation/>" ]]; then
		echo ""
		else
		result=$(grep -A5 "from=\"$time\"" ~/.cache/weather.xml | sed -n 3p | cut -d'"' -f4 | awk '{ print $1 }' | awk '{printf "%0.2f\n",$1}')
		echo Possib. Chuva $result mm
		fi
	    elif (( $hora >= 10#0600 && $hora < 10#0900 )); then
	      time=$(date --date="now" +%Y-%m-%dT09:00:00)
	      result=$(grep -A5 "from=\"$time\"" ~/.cache/weather.xml | sed -n 3p | cut -d'"' -f4 | awk '{ print $1 }')
		if [[ $result == "<precipitation/>" ]]; then
		echo ""
		else
		result=$(grep -A5 "from=\"$time\"" ~/.cache/weather.xml | sed -n 3p | cut -d'"' -f4 | awk '{ print $1 }' | awk '{printf "%0.2f\n",$1}')
		echo Possib. Chuva $result mm
		fi
	    elif (( $hora >= 10#0900 && $hora < 10#1200 )); then
	      time=$(date --date="now" +%Y-%m-%dT12:00:00)
	      result=$(grep -A5 "from=\"$time\"" ~/.cache/weather.xml | sed -n 3p | cut -d'"' -f4 | awk '{ print $1 }')
		if [[ $result == "<precipitation/>" ]]; then
		echo ""
		else
		result=$(grep -A5 "from=\"$time\"" ~/.cache/weather.xml | sed -n 3p | cut -d'"' -f4 | awk '{ print $1 }' | awk '{printf "%0.2f\n",$1}')
		echo "Possib. Chuva" $result mm
		fi
	    elif (( $hora >= 10#1200 && $hora < 10#1500 )); then
	      time=$(date --date="now" +%Y-%m-%dT15:00:00)
	      result=$(grep -A5 "from=\"$time\"" ~/.cache/weather.xml | sed -n 3p | cut -d'"' -f4 | awk '{ print $1 }')
		if [[ $result == "<precipitation/>" ]]; then
		echo ""
		else
		result=$(grep -A5 "from=\"$time\"" ~/.cache/weather.xml | sed -n 3p | cut -d'"' -f4 | awk '{ print $1 }' | awk '{printf "%0.2f\n",$1}')
		echo Possib. Chuva $result mm
		fi
	    elif (( $hora >= 10#1500 && $hora < 10#1800 )); then
	      time=$(date --date="now" +%Y-%m-%dT18:00:00)
	      result=$(grep -A5 "from=\"$time\"" ~/.cache/weather.xml | sed -n 3p | cut -d'"' -f4 | awk '{ print $1 }')
		if [[ $result == "<precipitation/>" ]]; then
		echo ""
		else
		result=$(grep -A5 "from=\"$time\"" ~/.cache/weather.xml | sed -n 3p | cut -d'"' -f4 | awk '{ print $1 }' | awk '{printf "%0.2f\n",$1}')
		echo Possib. Chuva $result mm
		fi
	    elif (( $hora >= 10#1800 && $hora < 10#2100 )); then
	      time=$(date --date="now" +%Y-%m-%dT21:00:00)
	      result=$(grep -A5 "from=\"$time\"" ~/.cache/weather.xml | sed -n 3p | cut -d'"' -f4 | awk '{ print $1 }')
		if [[ $result == "<precipitation/>" ]]; then
		echo ""
		else
		result=$(grep -A5 "from=\"$time\"" ~/.cache/weather.xml | sed -n 3p | cut -d'"' -f4 | awk '{ print $1 }' | awk '{printf "%0.2f\n",$1}')
		echo Possib. Chuva $result mm
		fi
	    elif (( $hora >= 2100 && $hora <= 2359 )); then
	      time=$(date  --date="1 day" +%Y-%m-%dT00:00:00)
	      result=$(grep -A5 "from=\"$time\"" ~/.cache/weather.xml | sed -n 3p | cut -d'"' -f4 | awk '{ print $1 }')
		if [[ $result == "<precipitation/>" ]]; then
		echo ""
		else
		result=$(grep -A5 "from=\"$time\"" ~/.cache/weather.xml | sed -n 3p | cut -d'"' -f4 | awk '{ print $1 }' | awk '{printf "%0.2f\n",$1}')
		echo Possib. Chuva $result mm
		fi
	    fi

	  else

	  echo Chuva $chuva mm

	  fi

          ;;

     *)


esac

