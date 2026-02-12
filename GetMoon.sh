#!/bin/bash
# -------------------------------------------------------------------
# File: GetMoon.sh                                       /\
# Type: Bash Shell Script                               /_.\
# By Fernando Gilli fernando<at>wekers(dot)org    _,.-'/ `",\'-.,_
# Last modified:2026-02-04                     -~^    /______\`~~-^~:
# -------------------------------------------------------------------
#
# Description:
# This script renders a physically-based Moon image locally.
# The lunar disk is mathematically generated on each execution
# using astronomical formulas and geometric projection.
#
# No external APIs or network access are required.
#
# Rendering Pipeline:
# 1. Retrieve real lunar age using Perl (Astro::MoonPhase)
# 2. Compute illuminated fraction astronomically
# 3. Generate curved terminator mask using ImageMagick -fx
# 4. Multiply mask with high-resolution lunar texture
# 5. Apply subtle gamma correction (phase-aware)
# 6. Apply hemisphere orientation correction
#
# Requirements:
# - ImageMagick v7+
# - Perl module Astro::MoonPhase
# - moon_texture.jpg located in ~/.conky/wekers
#
# Compatible with:
# Linux / FreeBSD / X11 environments
#
# -------------------------------------------------------------------

export LC_ALL=C   # Force dot decimal separator for awk/ImageMagick consistency

DirShell="$HOME/.conky/wekers"
RAW="$DirShell/raw"
IMG="$DirShell/moon.jpg"
LIGHT="$DirShell/light.png"
TEXTURE="$DirShell/moon_texture.jpg"

HEMISPHERE="s"      # "n" = Northern Hemisphere | "s" = Southern Hemisphere

SIZE=512
CENTER=$((SIZE/2))
RADIUS=$CENTER

# -------------------------------------------------------
# Obtain real lunar age (in days) via Perl helper script
# -------------------------------------------------------
AGE_DAYS=$(perl "$DirShell/moon_age.pl")
SYNODIC_MONTH=29.53058867

# Normalize lunar age into phase fraction (0.0 – 1.0)
AGE_FRAC=$(awk -v age="$AGE_DAYS" -v sm="$SYNODIC_MONTH" 'BEGIN {
    f = age / sm
    if (f > 1) f -= int(f)
    print f
}')

# -------------------------------------------------------
# Compute illuminated percentage (astronomically correct)
# Formula: (1 - cos(2πf)) / 2
# -------------------------------------------------------
ILLUM=$(awk -v f="$AGE_FRAC" 'BEGIN {
    pi=3.141592653589793
    illum = (1 - cos(2*pi*f)) / 2
    printf "%.0f", illum * 100
}')

# -------------------------------------------------------
# Determine phase name (8 classical lunar phases)
# -------------------------------------------------------
PHASE_NAME=$(awk -v f="$AGE_FRAC" 'BEGIN {
    tol = 0.02
    if (f < tol || f > 1 - tol)
        print "New Moon"
    else if (f > 0.25 - tol && f < 0.25 + tol)
        print "First Quarter"
    else if (f > 0.50 - tol && f < 0.50 + tol)
        print "Full Moon"
    else if (f > 0.75 - tol && f < 0.75 + tol)
        print "Last Quarter"
    else if (f < 0.25)
        print "Waxing Crescent"
    else if (f < 0.50)
        print "Waxing Gibbous"
    else if (f < 0.75)
        print "Waning Gibbous"
    else
        print "Waning Crescent"
}')

# -------------------------------------------------------
# Compute illuminated fraction (0–1) for mask rendering
# -------------------------------------------------------
K=$(awk -v f="$AGE_FRAC" 'BEGIN {
    pi=3.141592653589793
    print (1 - cos(2*pi*f)) / 2
}')

# -------------------------------------------------------
# Generate curved terminator mask
# The mask models a spherical surface lit by the Sun,
# producing a physically accurate ovulated shadow edge.
# -------------------------------------------------------

# Determine waxing (+1) or waning (-1) orientation
SIDE=$(awk -v f="$AGE_FRAC" 'BEGIN{print (f<0.5)?1:-1}')

# Approximate lunar disk tilt (visual rotation)
ANGLE=$(awk -v f="$AGE_FRAC" 'BEGIN{
    pi=3.141592653589793
    print 25*sin(2*pi*f)
}')

# Convert degrees to radians
RAD=$(awk -v a="$ANGLE" 'BEGIN {
    pi=3.141592653589793
    printf "%.8f", a*pi/180
}')

COS=$(awk -v r="$RAD" 'BEGIN{print cos(r)}')
SIN=$(awk -v r="$RAD" 'BEGIN{print sin(r)}')

# Render light mask using rotated coordinate system
magick -size ${SIZE}x${SIZE} xc:black \
  -fx "dx=(i-$CENTER)/$RADIUS;
       dy=(j-$CENTER)/$RADIUS;
       xr=dx*$COS - dy*$SIN;
       yr=dx*$SIN + dy*$COS;
       hypot(dx,dy)>1 ? 0 :
       ($SIDE*xr) > ((1-2*$K)*sqrt(1-yr*yr)) ? 1 : 0.12" \
  "$LIGHT"

# Apply slight blur to soften terminator transition
magick "$LIGHT" -blur 0x0.8 "$LIGHT"

# -------------------------------------------------------
# Apply mask to lunar texture
# -------------------------------------------------------
magick "$TEXTURE" -resize ${SIZE}x${SIZE} \
  "$DirShell/texture_resized.png"

# Subtle gamma correction depending on illumination
# Prevents flat appearance near full moon
if (( ILLUM > 85 )); then
    GAMMA=0.99
elif (( ILLUM < 35 )); then
    GAMMA=0.96
else
    GAMMA=1.00
fi

magick "$DirShell/texture_resized.png" "$LIGHT" \
  -compose Multiply -composite \
  -gamma $GAMMA \
  "$IMG"

# -------------------------------------------------------
# Hemisphere correction
# Southern Hemisphere requires horizontal mirroring
# -------------------------------------------------------
if [[ "$HEMISPHERE" == "s" ]]; then
    magick "$IMG" -flop "$IMG"
fi

# Cleanup temporary files
rm -f "$LIGHT" "$DirShell/texture_resized.png"

# -------------------------------------------------------
# Update Conky RAW output
# -------------------------------------------------------
echo "$PHASE_NAME" > "$RAW"
echo "Illumination : $ILLUM%" >> "$RAW"

# Update next New/Full Moon info
sh ${DirShell}/lune_die.sh > /dev/null 2>&1

exit 0
