#!/usr/bin/perl
# -------------------------------------------------------------------
# File: moon.pl
# Type: Perl Script
# Author: Fernando Gilli
# Last modified: 2026-01-29
# -------------------------------------------------------------------
#
# Description:
# Calculates the next Full Moon and next New Moon
# within a 30-day window using Astro::MoonPhase.
#
# The script writes a 4-line file:
#
# Line 0 → Full Moon label
# Line 1 → Full Moon date or countdown
# Line 2 → New Moon label
# Line 3 → New Moon date or countdown
#
# Output file:
#   moon_phase_die
#
# This file is later consumed by lune_die.sh
# for translation and Conky display.
#
# Requirement:
#   perl -MCPAN -e 'install Astro::MoonPhase'
#
# Compatible with:
# Linux / FreeBSD / X environments
# -------------------------------------------------------------------

use strict;
use warnings;
use POSIX qw(strftime);
use Astro::MoonPhase;

my $file = 'moon_phase_die';

# Ensure minimal structure (4 lines always written)
my @list = ("", "", "", "");

# -------------------------------------------------------
# Define search interval (now → next 30 days)
# -------------------------------------------------------

my $now   = time();
my $start = $now;
my $stop  = $start + 30 * 24 * 60 * 60;  # 30 days ahead

# Moon phase index mapping (0–3)
my @name = (
    "New Moon",
    "First Quarter",
    "Full Moon",
    "Last Quarter"
);

# Retrieve phase sequence in interval
my ($phase, @times) = phaselist($start, $stop);

my $found_full = 0;
my $found_new  = 0;

# -------------------------------------------------------
# Iterate through upcoming phase transitions
# -------------------------------------------------------

while (@times) {

    my $time_next = shift @times;

    # Compute time delta once
    my $delta = $time_next - $now;

    my $days  = int($delta / 86400);
    my $hours = int(($delta % 86400) / 3600);
    my $mins  = int(($delta % 3600) / 60);

    # -------------------------------
    # FULL MOON (phase index = 2)
    # -------------------------------

    if ($phase == 2 && !$found_full) {

        $found_full = 1;
        $list[0] = "$name[$phase]\n";

        if ($days == 0 && $hours > 0) {
            $list[1] = "in $hours hr\n";
        }
        elsif ($days == 0 && $hours == 0) {
            $list[1] = "in $mins min\n";
        }
        else {
            $list[1] = ucfirst strftime("%-d %b\n", localtime($time_next));
        }
    }

    # -------------------------------
    # NEW MOON (phase index = 0)
    # -------------------------------

    if ($phase == 0 && !$found_new) {

        $found_new = 1;
        $list[2] = "$name[$phase]\n";

        if ($days == 0 && $hours > 0) {
            $list[3] = "in $hours hr\n";
        }
        elsif ($days == 0 && $hours == 0) {
            $list[3] = "in $mins min\n";
        }
        else {
            $list[3] = ucfirst strftime("%-d %b\n", localtime($time_next));
        }
    }

    # Advance phase index cyclically (0–3)
    $phase = ($phase + 1) % 4;

    # Exit early if both events were found
    last if ($found_full && $found_new);
}

# -------------------------------------------------------
# Write output file once
# -------------------------------------------------------

open(my $fh, '>', $file)
    or die "Cannot write $file: $!";

print $fh @list;

close $fh;

exit 0;
