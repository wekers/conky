#!/bin/bash


# -------------------------------------------------------------------
# File: lune_die.sh                                      /\
# Type: Bash Shell Script                               /_.\
# By Fernando Gilli fernando<at>wekers(dot)org    _,.-'/ `",\'-.,_
# Last modified:2023-09-17                     -~^    /______\`~~-^~:
# ------------------------
# Get Moon data from moongiant.com
# / OS : $Linux, $FreeBSD (X Window)
# -------------------------------------------------------------------

# set language
lang="pt-br"

# put your hemisphere here:
# n for north
# s for south
hemisphere="s"

# Working directory
DirShell="$HOME/.conky/wekers"


# blocked, because now requires cookies and javascript
# so bypass die.net
# create account on https://www.scraping-bot.io
# substitue below with your username and your api_key
url='https://www.die.net/moon/'
username='your username'
api_key='your apikey'
auth=$(echo -ne "$username:$api_key" | base64);

curl -X POST \
  http://api.scraping-bot.io/scrape/raw-html \
  -H "Authorization: Basic $auth" \
  -H "Content-Type: application/json" \
  -d "{\"url\":\"$url\"}" \
  -o ${DirShell}/moon_cal_die

  
touch ${DirShell}/moon_phase_die

egrep -i '</td></tr>|<img src=|<small>' ${DirShell}/moon_cal_die > ${DirShell}/moon_phase_die
sed -i -e '1,1d' ${DirShell}/moon_phase_die # remove first line
sed -i 's/&nbsp;/ /g' ${DirShell}/moon_phase_die
sed -i 's/, /\n/g' ${DirShell}/moon_phase_die
sed -i 's/<img src="/\n/g' ${DirShell}/moon_phase_die
sed -i 's/" alt="/\n/g' ${DirShell}/moon_phase_die
sed -i 's/\[/</g' ${DirShell}/moon_phase_die
sed -i 's|<[^>]*>||g' ${DirShell}/moon_phase_die
sed -i -e'/^$/d' ${DirShell}/moon_phase_die

sed -i -e '1,4d' ${DirShell}/moon_phase_die
sed -i -e '2d' ${DirShell}/moon_phase_die
sed -i -e '3,4d' ${DirShell}/moon_phase_die
sed -i -e '4d' ${DirShell}/moon_phase_die
sed -i -e '5,6d' ${DirShell}/moon_phase_die
sed -i -e 's/(GMT)//g' ${DirShell}/moon_phase_die
sed -i -e 's/Next://g' ${DirShell}/moon_phase_die
sed -i -e 's/at.*//' ${DirShell}/moon_phase_die 

[ -f ${DirShell}/moon_cal_die ] && rm ${DirShell}/moon_cal_die



# Translate pt-br
if [[ $lang == "pt-br" ]]; then
	  sed -i -e 's/New Moon/Lua Nova/g' ${DirShell}/moon_phase_die
          sed -i -e 's/Full Moon/Lua Cheia/g' ${DirShell}/moon_phase_die
          sed -i -e 's/Waxing Crescent/Lua Crescente/g' ${DirShell}/moon_phase_die
          sed -i -e 's/Waxing Gibbous/Lua Crescente/g' ${DirShell}/moon_phase_die
          sed -i -e 's/Waning Crescent/Lua Minguante/g' ${DirShell}/moon_phase_die
          sed -i -e 's/Waning Gibbous/Lua Minguante/g' ${DirShell}/moon_phase_die
          sed -i -e 's/First Quarter/Quarto Crescente/g' ${DirShell}/moon_phase_die
          sed -i -e 's/Last Quarter/Quarto Minguante/g' ${DirShell}/moon_phase_die
     #months
          sed -i -e 's/Feb/Fev/g' ${DirShell}/moon_phase_die
          sed -i -e 's/Apr/Abr/g' ${DirShell}/moon_phase_die
          sed -i -e 's/May/Maio/g' ${DirShell}/moon_phase_die
          sed -i -e 's/Aug/Ago/g' ${DirShell}/moon_phase_die
          sed -i -e 's/Sep/Set/g' ${DirShell}/moon_phase_die
          sed -i -e 's/Oct/Out/g' ${DirShell}/moon_phase_die
          sed -i -e 's/Dec/Dez/g' ${DirShell}/moon_phase_die
     #others
          sed -i -e 's/in /em /g' ${DirShell}/moon_phase_die
          sed -i -e 's/and/e/g' ${DirShell}/moon_phase_die
          sed -i -e '/^$/d' ${DirShell}/moon_phase_die
          
          /usr/bin/sed -i -e 's/New Moon/Lua Nova/g' ${DirShell}/raw
	  /usr/bin/sed -i -e 's/Full Moon/Lua Cheia/g' ${DirShell}/raw
	  /usr/bin/sed -i -e 's/Waxing Crescent/Lua Crescente/g' ${DirShell}/raw
	  /usr/bin/sed -i -e 's/Waxing Gibbous/Lua Crescente/g' ${DirShell}/raw
	  /usr/bin/sed -i -e 's/Waning Crescent/Lua Minguante/g' ${DirShell}/raw
	  /usr/bin/sed -i -e 's/Waning Gibbous/Lua Minguante/g' ${DirShell}/raw
	  /usr/bin/sed -i -e 's/First Quarter/Quarto Crescente/g' ${DirShell}/raw
	  /usr/bin/sed -i -e 's/Last Quarter/Quarto Minguante/g' ${DirShell}/raw
fi

# mirror moon image, hemisphere south
if [[ $hemisphere == "s" ]]; then
  /usr/bin/convert -flop -colorspace rgb ${DirShell}/moon_tmp.jpg ${DirShell}/moon.jpg
  /usr/bin/rm ${DirShell}/moon_tmp.jpg
else
   /usr/bin/convert -colorspace rgb ${DirShell}moon_tmp.jpg ${DirShell}/moon.jpg
  /usr/bin/rm ${DirShell}/moon_tmp.jpg
fi

#EOF
