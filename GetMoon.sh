#!/bin/bash


# -------------------------------------------------------------------
# File: GetMoon.sh                                       /\
# Type: Bash Shell Script                               /_.\
# By Fernando Gilli fernando<at>wekers(dot)org    _,.-'/ `",\'-.,_
# Last modified:2019-09-16                     -~^    /______\`~~-^~:
# ------------------------
# Get Moon data from moongiant.com
# / OS : $Linux, $FreeBSD (X Window)
# -------------------------------------------------------------------


#lang to translate moon phase name
lang=pt-br

#function: moonrise_set
moonrise_set () {
    case "$1" in
        "FirstQuarter")
                        echo "Noon/Midnight"
        ;;
        "FullMoon")
                        echo "6PM/6AM"
                ;;       
                "LastQuarter")
                        echo "Midnight/Noon"
                ;;       
                "NewMoon")
                        echo "6AM/6PM"
                ;;
                "WaningCrescent")
                        echo "3AM/3PM"
                ;;
                "WaningGibbous")
                        echo "9PM/9AM"
                ;;
                "WaxingCrescent")
                        echo "9AM/9PM"
                ;;
                "WaxingGibbous")
                        echo "3PM/3AM"
                ;;
                *)
                        echo "Unavailable"
                esac
}


#put your hemisphere here: n for north, s for south
hemisphere=s

wget -O $HOME/.conky/wekers/raw "http://www.moongiant.com/phase/today" > /dev/null 2>&1

rm $HOME/.conky/wekers/moon2.jpg
rm $HOME/.conky/wekers/moon.jpg

sed -i -e '/^ *$/d' -e 's/^ *//g' $HOME/.conky/wekers/raw
sed -i '/var jArray=\|"todayMoonContainer"/!d' $HOME/.conky/wekers/raw
sed -i -e '/var jArray/s/","/\n/g' -e 's/<span>\|<b>\|<\\\/span>\|<\\\/b>\|\\n//g' $HOME/.conky/wekers/raw
sed -i 's/"\].*\[\"/\n/g' $HOME/.conky/wekers/raw
sed -i '/var jArray/d' $HOME/.conky/wekers/raw
sed -i -e 's/"\]};//g' -e 's/^.*today_phase\///g' -e 's/\.jpg.*$//g' $HOME/.conky/wekers/raw
phase=$(sed -n 7p $HOME/.conky/wekers/raw|sed 's/ //')
mrise_mset=$(moonrise_set $phase)
sed -i 7a$(moonrise_set $phase) $HOME/.conky/wekers/raw
img_in=$(sed -n 49p $HOME/.conky/wekers/raw)
wget --output-document=$HOME/.conky/wekers/moon2.jpg https://static.die.net/moon/210.jpg > /dev/null 2>&1
#wget --output-document=$HOME/.conky/wekers/moon2.jpg https://www.moongiant.com/images/today_phase/$img_in.jpg > /dev/null 2>&1
sleep 1
#mirror moon image, hemisphere south
if [[ $hemisphere == s ]]; then
  convert -flop ~/.conky/wekers/moon2.jpg ~/.conky/wekers/moon.jpg
else
  mv ~/.conky/wekers/moon2.jpg ~/.conky/wekers/moon.jpg
fi


#translate pt-br
if [[ $lang == pt-br ]]; then
  sed -i -e 's/New Moon/Lua Nova/g' ~/.conky/wekers/raw
  sed -i -e 's/Full Moon/Lua Cheia/g' ~/.conky/wekers/raw
  sed -i -e 's/Waxing Crescent/Lua Crescente/g' ~/.conky/wekers/raw
  sed -i -e 's/Waxing Gibbous/Lua Crescente/g' ~/.conky/wekers/raw
  sed -i -e 's/Waning Crescent/Lua Minguante/g' ~/.conky/wekers/raw
  sed -i -e 's/Waning Gibbous/Lua Minguante/g' ~/.conky/wekers/raw
  sed -i -e 's/First Quarter/Quarto Crescente/g' ~/.conky/wekers/raw
  sed -i -e 's/Last Quarter/Quarto Minguante/g' ~/.conky/wekers/raw
fi