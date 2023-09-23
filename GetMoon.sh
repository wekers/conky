#!/bin/bash


# -------------------------------------------------------------------
# File: GetMoon.sh                                       /\
# Type: Bash Shell Script                               /_.\
# By Fernando Gilli fernando<at>wekers(dot)org    _,.-'/ `",\'-.,_
# Last modified:2023-09-23                     -~^    /______\`~~-^~:
# ------------------------
# Get Moon data from moongiant.com
# / OS : $Linux, $FreeBSD (X Window)
# -------------------------------------------------------------------

# ****************************

# Working directory
DirShell="$HOME/.conky/wekers"

# set language
lang="pt-br"

# put your hemisphere here:
# n for north
# s for south
hemisphere="s"

# ****************************

wget -q -O ${DirShell}/raw "http://www.moongiant.com/phase/today" > /dev/null 2>&1

[ -f ${DirShell}/moon_tmp.jpg ] && rm ${DirShell}/moon_tmp.jpg
[ -f ${DirShell}/moon.jpg ] && rm ${DirShell}/moon.jpg

sed -i -e '/^ *$/d' -e 's/^ *//g' ${DirShell}/raw
sed -i '/Illumination/!d' ${DirShell}/raw
sed -i 's/<br>/\n/g' ${DirShell}/raw
sed -i 's|<[^>]*>||g' ${DirShell}/raw
sed -i -e '4d' ${DirShell}/raw

now=$(date --date="now" +%H)

# Moon image
wget -q -O ${DirShell}/get_moon_icon_tmp "https://moon.nasa.gov/moon-observation/daily-moon-guide/" > /dev/null 2>&1
#sed -i -e 's/\(.*\)/\L\1/' ${DirShell}/get_moon_icon_tmp # transform all lowercase
now_ico="$(LANG=en_us_88591 date +'%d %b %Y')"
  
grep -E -o "${now_ico}.{0,428}" ${DirShell}/get_moon_icon_tmp | \
sed 's/&quot;/ /g'| sed 's/, /\n/g' | sed -e '2,13d' | sed 's/image_src ://g' | \
sed 's/^ *//g' | sed 's/\.jpg.*/.jpg/' > ${DirShell}/get_moon_icon
  
img_ico=$(sed -n 2p ${DirShell}/get_moon_icon)

wget -q --output-document=${DirShell}/moon_tmp.jpg https://moon.nasa.gov/$img_ico > /dev/null 2>&1

[ -f ${DirShell}/get_moon_icon_tmp ] && rm  ${DirShell}/get_moon_icon_tmp
  

# Translate pt-br (moon phase name)
if [[ $lang == "pt-br" ]]; then

          /usr/bin/sed -i -e 's/New Moon/Lua Nova/g' ${DirShell}/raw
	  /usr/bin/sed -i -e 's/Full Moon/Lua Cheia/g' ${DirShell}/raw
	  /usr/bin/sed -i -e 's/Waxing Crescent/Lua Crescente/g' ${DirShell}/raw
	  /usr/bin/sed -i -e 's/Waxing Gibbous/Lua Crescente/g' ${DirShell}/raw
	  /usr/bin/sed -i -e 's/Waning Crescent/Lua Minguante/g' ${DirShell}/raw
	  /usr/bin/sed -i -e 's/Waning Gibbous/Lua Minguante/g' ${DirShell}/raw
	  /usr/bin/sed -i -e 's/First Quarter/Quarto Crescente/g' ${DirShell}/raw
	  /usr/bin/sed -i -e 's/Last Quarter/Quarto Minguante/g' ${DirShell}/raw

fi


# exec too
sh ${DirShell}/lune_die.sh > /dev/null 2>&1

#EOF
