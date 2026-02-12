#!/usr/bin/perl
# -------------------------------------------------------------------
# File: moon_age.pl
# Type: Perl Script
# Author: Fernando Gilli
# -------------------------------------------------------------------
#
# Description:
# Returns the current lunar age in days.
#
# Uses the Perl module Astro::MoonPhase to compute
# the precise lunar phase for the current timestamp.
#
# Output:
# Prints a single numeric value (age in days).
#
# Example:
#   12.734582
#
# This value is consumed by GetMoon.sh to calculate:
# - Normalized phase fraction
# - Illuminated percentage
# - Terminator rendering
#
# Requirement:
#   perl -MCPAN -e 'install Astro::MoonPhase'
#
# -------------------------------------------------------------------

use strict;
use warnings;
use Astro::MoonPhase;

# Current Unix timestamp
my $now = time();

# phase() returns:
#   $phase  -> phase angle (radians)
#   $illum  -> illuminated fraction (0–1)
#   $age    -> lunar age in days
my ($phase, $illum, $age) = phase($now);

# Print only lunar age (days)
print "$age\n";
