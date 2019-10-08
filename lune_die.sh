#!/bin/bash


# -------------------------------------------------------------------
# File: lune_die.sh                                      /\
# Type: Bash Shell Script                               /_.\
# By Fernando Gilli fernando<at>wekers(dot)org    _,.-'/ `",\'-.,_
# Last modified:2019-09-30                     -~^    /______\`~~-^~:
# ------------------------
# Get Moon data from moongiant.com
# / OS : $Linux, $FreeBSD (X Window)
# -------------------------------------------------------------------

# set language
lang="pt-br"

# Working directory
DirShell="$HOME/.conky/wekers"


wget -O ${DirShell}/moon_cal_die http://www.die.net/moon/ > /dev/null 2>&1

touch ${DirShell}/moon_phase_die


egrep -i '</td></tr>|<img src=|<small>' ${DirShell}/moon_cal_die > ${DirShell}/moon_phase_die
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
     #others
          sed -i -e 's/in /em /g' ${DirShell}/moon_phase_die
          sed -i -e 's/and/e/g' ${DirShell}/moon_phase_die
          sed -i -e '/^$/d' ${DirShell}/moon_phase_die
fi

#EOF
