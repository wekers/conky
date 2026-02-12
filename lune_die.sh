#!/bin/bash
# -------------------------------------------------------------------
# File: lune_die.sh
# Type: Bash Shell Script
# Author: Fernando Gilli
# Last modified: 2026-01-29
# -------------------------------------------------------------------
#
# Description:
# Retrieves next Full Moon and New Moon using Astro::MoonPhase.
# Translates output to Portuguese (optional).
# No external HTTP requests.
#
# -------------------------------------------------------------------

# Language
lang="pt-br"

# Working directory
DirShell="$HOME/.conky/wekers"
cd "$DirShell" || exit 1

FILE1="$DirShell/moon_phase_die"
FILE2="$DirShell/raw"

# Ensure file exists
touch "$FILE1"

# Execute phase calculation
perl "$DirShell/moon.pl"

# Small delay to ensure file write completion
sleep 1

# -----------------------------------------------------------
# Translate to pt-br
# -----------------------------------------------------------

if [[ "$lang" == "pt-br" ]]; then

    # ---- Translate moon_phase_die (phases + months + helpers) ----
    sed -i \
        -e 's/New Moon/Lua Nova/g' \
        -e 's/Full Moon/Lua Cheia/g' \
        -e 's/First Quarter/Quarto Crescente/g' \
        -e 's/Last Quarter/Quarto Minguante/g' \
        -e 's/Waxing Crescent/Lua Crescente/g' \
        -e 's/Waxing Gibbous/Lua Gibosa Crescente/g' \
        -e 's/Waning Gibbous/Lua Gibosa Minguante/g' \
        -e 's/Waning Crescent/Lua Minguante/g' \
        -e 's/Feb/Fev/g' \
        -e 's/Apr/Abr/g' \
        -e 's/May/Maio/g' \
        -e 's/Aug/Ago/g' \
        -e 's/Sep/Set/g' \
        -e 's/Oct/Out/g' \
        -e 's/Dec/Dez/g' \
        -e 's/in /em /g' \
        -e 's/and/e/g' \
        -e '/^$/d' \
        "$FILE1"

    # ---- Translate raw (phase names only) ----
    sed -i \
        -e 's/New Moon/Lua Nova/g' \
        -e 's/Full Moon/Lua Cheia/g' \
        -e 's/First Quarter/Quarto Crescente/g' \
        -e 's/Last Quarter/Quarto Minguante/g' \
        -e 's/Waxing Crescent/Lua Crescente/g' \
        -e 's/Waxing Gibbous/Lua Gibosa Crescente/g' \
        -e 's/Waning Gibbous/Lua Gibosa Minguante/g' \
        -e 's/Waning Crescent/Lua Minguante/g' \
        "$FILE2"
fi

exit 0
