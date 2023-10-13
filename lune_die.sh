#!/bin/bash


# -------------------------------------------------------------------
# File: lune_die.sh                                      /\
# Type: Bash Shell Script                               /_.\
# By Fernando Gilli fernando<at>wekers(dot)org    _,.-'/ `",\'-.,_
# Last modified:2023-10-13                     -~^    /______\`~~-^~:
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

cd ${DirShell}
touch ${DirShell}/moon_phase_die

perl moon.pl

sleep 3
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
