#!/bin/bash

#sleep 2
#killall -9 conky  

sleep 2
Pid=$(pidof conky  )
ps --pid "$Pid"  > /dev/null 2>&1
# shellcheck disable=SC2181
if [ "$?" -eq 0 ]; then #igual
    echo "conky is already running. PID $Pid"
    exit 0
else
   #sleep 5 && conky -c /home/fernando/.conky/wekers/.conkyrc_1080p &
   sleep 5 && conky -c /home/fernando/.conky/wekers/conkyrc/.conkyrc_2k &
   #sleep 5 && nice conky -c /home/fernando/.conky/wekers/.conkyrc &
   exit 0
fi
