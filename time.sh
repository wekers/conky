#!/bin/bash

# -------------------------------------------------------------------
# File: time.sh                                          /\
# Type: Bash Shell Script                               /_.\
# By Fernando Gilli fernando<at>wekers(dot)org    _,.-'/ `",\'-.,_
# Last modified:2021-04-14                     -~^    /______\`~~-^~:
# ------------------------
# Manipulate data of weather
# / OS : $Linux, $FreeBSD (X Window)
# -------------------------------------------------------------------


# set language
lang="pt-br"

#Working directory
DirShell="$HOME/.conky/wekers"


case $lang in

     # translate pt-br
     pt-br)
          cpre="--> "
          cprec="Possib. Chuva"
          rain="--> Chuva"
          proxlem=$(sed -n 4p ${DirShell}/moon_phase_die | tr ' ' '\n'|tac| tr '\n' ' ' | cut -c1-22)
          proxlemc=$(sed -n 4p ${DirShell}/moon_phase_die | cut -c1-9)
          proxlemcfull=$(sed -n 2p ${DirShell}/moon_phase_die | cut -c1-9)
          proxlfullem=$(sed -n 2p ${DirShell}/moon_phase_die | tr ' ' '\n'|tac| tr '\n' ' ' | cut -c1-22)
          on="em"
          mm="mm"
          prox="Próx"
          feels="Sensação Térmica"
          windv=$(grep "speed" ~/.cache/weather_current.xml | cut -d'"' -f6 \
			     | sed -e 's/Light breeze/Brisa Leve/g' \
			     | sed -e 's/Moderate breeze/Brisa Moderada/g' \
			     | sed -e 's/Fresh Breeze/Brisa Fresca/g' \
			     | sed -e 's/Gentle Breeze/Brisa Suave/g' \
			     | sed -e 's/Strong breeze/Brisa Forte/g' \
			     | sed -e 's/Calm/Brisa Calma/g' \
			     | sed -e 's/High wind, near gale/Vento Forte, vendaval perto/g' )
;;

*)
          # default
          cpre="--> "
          cprec="Chance of Precipitation"
          rain="--> Rain"
          proxlemc=$(sed -n 4p ${DirShell}/moon_phase_die | cut -c1-9);
          proxlem=$proxlemc
          proxlfullem=$(sed -n 2p ${DirShell}/moon_phase_die | cut -c1-22)
          on="in"
          mm="mm"
          prox="Next"
          windv=$(grep "speed" ~/.cache/weather_current.xml | cut -d'"' -f6)
          proxlemcfull=$(sed -n 2p ${DirShell}/moon_phase_die | cut -c1-9)
          feels="Feels Like"
          ;;

esac


case $1 in

      img)
          img_result=$(grep "number" ~/.cache/weather_current.xml | head -n 1 | cut -d'"' -f2)
	    if [[ $img_result -ne 800 && $img_result -ne 801 && $img_result -ne 802 && $img_result -ne 803 ]]; then
	      cp -f ${DirShell}/images/$(grep "number" ~/.cache/weather_current.xml | head -n 1 | cut -d'"' -f2).png ~/.cache/weather.png
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

      wname)
          result=$windv
	    if [[ $result != "Setting" ]]; then
		     echo "$result"
	    else
	      echo ""
	    fi
	  ;;

      wicon)
	  cp -f ${DirShell}/images/wind/orange_$(grep "direction" ~/.cache/weather_current.xml | head -n 1 | cut -d'"' -f4 | tr [[:upper:]] [[:lower:]] | sed -e 's/^[[:space:]]*//g' -e 's/[[:space:]]*\$//g').png ~/.cache/wind.png
	  ;;

      1max)
	  time=$(date --date="1 day" +%Y-%m-%dT15:00:00)
	  result=$(grep -A6 "from=\"$time\"" ~/.cache/weather.xml | sed -n 7p | cut -d'"' -f8 | cut -d'.' -f1)
	  echo "$result"
          ;;

      2max)
	  time=$(date --date="2 day" +%Y-%m-%dT15:00:00)
	  result=$(grep -A6 "from=\"$time\"" ~/.cache/weather.xml | sed -n 7p | cut -d'"' -f8 | cut -d'.' -f1)
	  echo "$result"
          ;;

      3max)
	  time=$(date --date="3 day" +%Y-%m-%dT15:00:00)
	  result=$(grep -A6 "from=\"$time\"" ~/.cache/weather.xml | sed -n 7p | cut -d'"' -f8 | cut -d'.' -f1)
	  echo "$result"
          ;;

      1min)
	  time=$(date --date="1 day" +%Y-%m-%dT06:00:00)
	  result=$(grep -A6 "from=\"$time\"" ~/.cache/weather.xml | sed -n 7p | cut -d'"' -f6 | cut -d'.' -f1)
	  echo "$result"
          ;;

      2min)
	  time=$(date --date="2 day" +%Y-%m-%dT06:00:00)
	  result=$(grep -A6 "from=\"$time\"" ~/.cache/weather.xml | sed -n 7p | cut -d'"' -f6 | cut -d'.' -f1)
	  echo "$result"
          ;;

      3min)
	  time=$(date --date="3 day" +%Y-%m-%dT06:00:00)
	  result=$(grep -A6 "from=\"$time\"" ~/.cache/weather.xml | sed -n 7p | cut -d'"' -f6 | cut -d'.' -f1)
	  echo "$result"
          ;;

      weather-1)
	  time=$(date --date="1 day" +%Y-%m-%dT12:00:00)
	  result=$(grep -A1 "from=\"$time\"" ~/.cache/weather.xml | sed -n 2p | cut -d'"' -f2)
	    if [[ $result -eq 800 || $result -eq 801 || $result -eq 802 || $result -eq 803 ]]; then
	      result=$(grep -A1 "from=\"$time\"" ~/.cache/weather.xml | sed -n 2p | cut -d'"' -f6)
	    fi
	  cp -f ${DirShell}/images/$result.png ~/.cache/weather-1.png
          ;;

      weather-2)
	  time=$(date --date="2 day" +%Y-%m-%dT12:00:00)
	  result=$(grep -A1 "from=\"$time\"" ~/.cache/weather.xml | sed -n 2p | cut -d'"' -f2)
	    if [[ $result -eq 800 || $result -eq 801 || $result -eq 802 || $result -eq 803 ]]; then
	      result=$(grep -A1 "from=\"$time\"" ~/.cache/weather.xml | sed -n 2p | cut -d'"' -f6)
	    fi
	  cp -f ${DirShell}/images/$result.png ~/.cache/weather-2.png
          ;;

      weather-3)
	  time=$(date --date="3 day" +%Y-%m-%dT12:00:00)
	  result=$(grep -A1 "from=\"$time\"" ~/.cache/weather.xml | sed -n 2p | cut -d'"' -f2)
	    if [[ $result -eq 800 || $result -eq 801 || $result -eq 802 || $result -eq 803 ]]; then
	      result=$(grep -A1 "from=\"$time\"" ~/.cache/weather.xml | sed -n 2p | cut -d'"' -f6)
	    fi
	  cp -f ${DirShell}/images/$result.png ~/.cache/weather-3.png
          ;;

      cast-1)
          time=$(date --date="1 day" +%Y-%m-%dT12:00:00)
	  result=$(grep -A5 "from=\"$time\"" ~/.cache/weather.xml | sed -n 2p | cut -d'"' -f4 | cut -d'.' -f1 | sed 's/\([a-z]\)\([a-zA-Z0-9]*\)/\u\1\2/g')
	  echo "$result"
          ;;

      cast-2)
          time=$(date --date="2 day" +%Y-%m-%dT12:00:00)
	  result=$(grep -A5 "from=\"$time\"" ~/.cache/weather.xml | sed -n 2p | cut -d'"' -f4 | cut -d'.' -f1 | sed 's/\([a-z]\)\([a-zA-Z0-9]*\)/\u\1\2/g')
	  echo "$result"
          ;;

      cast-3)
          time=$(date --date="3 day" +%Y-%m-%dT12:00:00)
	  result=$(grep -A5 "from=\"$time\"" ~/.cache/weather.xml | sed -n 2p | cut -d'"' -f4 | cut -d'.' -f1 | sed 's/\([a-z]\)\([a-zA-Z0-9]*\)/\u\1\2/g')
	  echo "$result"
          ;;

      mnext)
	  proxl=$(sed -n 3p ${DirShell}/moon_phase_die)
	     if [ $(sed -n 4p ${DirShell}/moon_phase_die | wc -m) -gt 9 ]; then
		echo "   $proxl$proxlemc"
	     else
                echo "   $prox $proxl  --> $proxlem"

             fi
          ;;

      mnextfull)
          proxlfull=$(sed -n 1p ${DirShell}/moon_phase_die)
	     if [ $(sed -n 2p ${DirShell}/moon_phase_die | wc -m) -gt 9 ]; then
		echo "   $proxlfull$proxlemcfull"
	     else
                echo "   $prox $proxlfull --> $proxlfullem"

             fi
          ;;

      at)
          # Apparent temp calc
          temper=$(grep "temperature" ~/.cache/weather_current.xml | head -n 1 | cut -d'"' -f6)
          wspeed=$(grep "speed" ~/.cache/weather_current.xml | head -n 1 | cut -d'"' -f2)
          rh=$(grep "humidity" ~/.cache/weather_current.xml | head -n 1 | cut -d'"' -f2)
          rhcalc=$(echo "$rh/100" | bc -l)
          exp=$(echo "(17.27*$temper) / (237.7+$temper)" | bc -l)
          ex=$(echo "e($exp*l(6.105))" | bc -l)
          e=$(echo "$rhcalc*$ex" | bc -l)
          at=$(echo "$temper + (0.348 * $e) - (0.7 * wspeed) - 4" | bc -l)
          echo $at | awk '{print int($at+0.5)}'
          ;;

       atext)
	  echo $feels
	  ;;

       temp)
	  temperature=$(grep "temperature" ~/.cache/weather_current.xml | head -n 1 | cut -d'"' -f6 | awk '{print int($1+0.5)}')
	  echo "$temperature"
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
	        result=$(grep -A5 "from=\"$time\"" ~/.cache/weather.xml | sed -n 3p | cut -d'"' -f6 | awk '{ print $1 }')
		probability=$(grep -A5 "from=\"$time\"" ~/.cache/weather.xml | sed -n 3p | cut -d'"' -f2 | awk '{ print $1 }')
	      	      
		if [[ $result == "<precipitation/>" || $probability == "0" ]]; then
		   echo ""
		else
		   result=$(grep -A5 "from=\"$time\"" ~/.cache/weather.xml | sed -n 3p | cut -d'"' -f6 | awk '{ print $1 }' | awk '{printf "%0.2f\n",$1}')
		   if [ $result == "0.00" ]; then
		    result=""
		    mm=""
		   fi
		   probability=$(echo $probability*100 | bc | awk '{ print $1}' | awk '{printf "%0.0f\n",$1}')
		   echo " $cpre"$probability% $cprec $result $mm
		fi

              elif (( $hora >= 10#0300 && $hora < 10#0600 )); then

	        time=$(date --date="now" +%Y-%m-%dT06:00:00)
	        result=$(grep -A5 "from=\"$time\"" ~/.cache/weather.xml | sed -n 3p | cut -d'"' -f6 | awk '{ print $1 }')
		probability=$(grep -A5 "from=\"$time\"" ~/.cache/weather.xml | sed -n 3p | cut -d'"' -f2 | awk '{ print $1 }')
	      
	        if [[ $result == "<precipitation/>" || $probability == "0" ]]; then
		  echo ""
		else
		   result=$(grep -A5 "from=\"$time\"" ~/.cache/weather.xml | sed -n 3p | cut -d'"' -f6 | awk '{ print $1 }' | awk '{printf "%0.2f\n",$1}')
		   if [ $result == "0.00" ]; then
		    result=""
		    mm=""
		   fi
		   probability=$(echo $probability*100 | bc | awk '{ print $1}' | awk '{printf "%0.0f\n",$1}')
		   echo " $cpre"$probability% $cprec $result $mm
		fi

	      elif (( $hora >= 10#0600 && $hora < 10#0900 )); then

	        time=$(date --date="now" +%Y-%m-%dT09:00:00)
		result=$(grep -A5 "from=\"$time\"" ~/.cache/weather.xml | sed -n 3p | cut -d'"' -f6 | awk '{ print $1 }')
		probability=$(grep -A5 "from=\"$time\"" ~/.cache/weather.xml | sed -n 3p | cut -d'"' -f2 | awk '{ print $1 }')
	        
	        if [[ $result == "<precipitation/>" || $probability == "0" ]]; then
		   echo ""
		else
		   result=$(grep -A5 "from=\"$time\"" ~/.cache/weather.xml | sed -n 3p | cut -d'"' -f6 | awk '{ print $1 }' | awk '{printf "%0.2f\n",$1}')
		   if [ $result == "0.00" ]; then
		    result=""
		    mm=""
		   fi
		   probability=$(echo $probability*100 | bc | awk '{ print $1}' | awk '{printf "%0.0f\n",$1}')
		   echo " $cpre"$probability% $cprec $result $mm
		fi

	      elif (( $hora >= 10#0900 && $hora < 10#1200 )); then

	        time=$(date --date="now" +%Y-%m-%dT12:00:00)
	        result=$(grep -A5 "from=\"$time\"" ~/.cache/weather.xml | sed -n 3p | cut -d'"' -f6 | awk '{ print $1 }')
		probability=$(grep -A5 "from=\"$time\"" ~/.cache/weather.xml | sed -n 3p | cut -d'"' -f2 | awk '{ print $1 }')
	      
		if [[ $result == "<precipitation/>" || $probability == "0" ]]; then
		  echo ""
		else
		   result=$(grep -A5 "from=\"$time\"" ~/.cache/weather.xml | sed -n 3p | cut -d'"' -f6 | awk '{ print $1 }' | awk '{printf "%0.2f\n",$1}')
		   if [ $result == "0.00" ]; then
		    result=""
		    mm=""
		   fi
		   probability=$(echo $probability*100 | bc | awk '{ print $1}' | awk '{printf "%0.0f\n",$1}')
		   echo " $cpre"$probability% $cprec $result $mm
		fi

	      elif (( $hora >= 10#1200 && $hora < 10#1500 )); then

	        time=$(date --date="now" +%Y-%m-%dT15:00:00)
		result=$(grep -A5 "from=\"$time\"" ~/.cache/weather.xml | sed -n 3p | cut -d'"' -f6 | awk '{ print $1 }')
		probability=$(grep -A5 "from=\"$time\"" ~/.cache/weather.xml | sed -n 3p | cut -d'"' -f2 | awk '{ print $1 }')
	      
		if [[ $result == "<precipitation/>" || $probability == "0" ]]; then
		   echo ""
		else
		   result=$(grep -A5 "from=\"$time\"" ~/.cache/weather.xml | sed -n 3p | cut -d'"' -f6 | awk '{ print $1 }' | awk '{printf "%0.2f\n",$1}')
		   if [ $result == "0.00" ]; then
		    result=""
		    mm=""
		   fi
		   probability=$(echo $probability*100 | bc | awk '{ print $1}' | awk '{printf "%0.0f\n",$1}')
		   echo " $cpre"$probability% $cprec $result $mm
		fi

	      elif (( $hora >= 10#1500 && $hora < 10#1800 )); then

	        time=$(date --date="now" +%Y-%m-%dT18:00:00)
	        result=$(grep -A5 "from=\"$time\"" ~/.cache/weather.xml | sed -n 3p | cut -d'"' -f6 | awk '{ print $1 }')
		probability=$(grep -A5 "from=\"$time\"" ~/.cache/weather.xml | sed -n 3p | cut -d'"' -f2 | awk '{ print $1 }')
	      
		if [[ $result == "<precipitation/>" || $probability == "0" ]]; then
		   echo ""
		else
		   result=$(grep -A5 "from=\"$time\"" ~/.cache/weather.xml | sed -n 3p | cut -d'"' -f6 | awk '{ print $1 }' | awk '{printf "%0.2f\n",$1}')
		   if [ $result == "0.00" ]; then
		    result=""
		    mm=""
		   fi
		   probability=$(echo $probability*100 | bc | awk '{ print $1}' | awk '{printf "%0.0f\n",$1}')
		   echo " $cpre"$probability% $cprec $result $mm 
		fi

	      elif (( $hora >= 10#1800 && $hora < 10#2100 )); then

	        time=$(date --date="now" +%Y-%m-%dT21:00:00)
	        result=$(grep -A5 "from=\"$time\"" ~/.cache/weather.xml | sed -n 3p | cut -d'"' -f6 | awk '{ print $1 }')
		probability=$(grep -A5 "from=\"$time\"" ~/.cache/weather.xml | sed -n 3p | cut -d'"' -f2 | awk '{ print $1 }')
	      
		if [[ $result == "<precipitation/>" || $probability == "0" ]]; then
		   echo ""
		else
		   result=$(grep -A5 "from=\"$time\"" ~/.cache/weather.xml | sed -n 3p | cut -d'"' -f6 | awk '{ print $1 }' | awk '{printf "%0.2f\n",$1}')
		   if [ $result == "0.00" ]; then
		    result=""
		    mm=""
		   fi
		   probability=$(echo $probability*100 | bc | awk '{ print $1}' | awk '{printf "%0.0f\n",$1}')
		   echo " $cpre"$probability% $cprec $result $mm
		fi

              elif (( $hora >= 2100 && $hora <= 2359 )); then

	        time=$(date  --date="1 day" +%Y-%m-%dT00:00:00)
	        result=$(grep -A5 "from=\"$time\"" ~/.cache/weather.xml | sed -n 3p | cut -d'"' -f6 | awk '{ print $1 }')
		probability=$(grep -A5 "from=\"$time\"" ~/.cache/weather.xml | sed -n 3p | cut -d'"' -f2 | awk '{ print $1 }')
	      
		if [[ $result == "<precipitation/>" || $probability == "0" ]]; then
		   echo ""
		else
		   result=$(grep -A5 "from=\"$time\"" ~/.cache/weather.xml | sed -n 3p | cut -d'"' -f6 | awk '{ print $1 }' | awk '{printf "%0.2f\n",$1}')
		   if [ $result == "0.00" ]; then
		    result=""
		    mm=""
		   fi
		   probability=$(echo $probability*100 | bc | awk '{ print $1}' | awk '{printf "%0.0f\n",$1}')
		   echo " $cpre"$probability% $cprec $result $mm
		fi

              fi

          else

              echo " $rain" $chuva $mm

          fi
          ;;

       *)

esac

#EOF

