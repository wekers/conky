#!/usr/bin/perl -w

#to install, with sudo
#perl -MCPAN -e 'install Astro::MoonPhase'

# -------------------------------------------------------------------
# File: moon.pl                                          /\
# Type: Perl Script                                     /_.\
# By Fernando Gilli fernando<at>wekers(dot)org    _,.-'/ `",\'-.,_
# Last modified:2023-09-21                     -~^    /______\`~~-^~:
# ------------------------
# Get Moon data from perl module Astro::MoonPhase
# / OS : $Linux, $FreeBSD (X Window)
# -------------------------------------------------------------------


use warnings;
use strict;
use POSIX qw(strftime);

use Astro::MoonPhase;


my @phases = phasehunt();
#print "New Moon      = ", scalar(localtime($phases[0])), "\n";
#print "First quarter = ", scalar(localtime($phases[1])), "\n";
#print "Full moon     = ", scalar(localtime($phases[2])), "\n";
#print "Last quarter  = ", scalar(localtime($phases[3])), "\n";
#print "New Moon      = ", scalar(localtime($phases[4])), "\n";

open(my $fh, '>', 'moon_phase_die');
    
  print $fh "Full Moon\n";
  print $fh ucfirst strftime("%b %d", localtime($phases[2])), "\n";
  print $fh "New Moon\n";
  print $fh ucfirst strftime("%b %d", localtime($phases[4])), "\n";

close $fh;