#!/usr/bin/perl -w

#to install, with sudo
#perl -MCPAN -e 'install Astro::MoonPhase'

# -------------------------------------------------------------------
# File: moon.pl                                          /\
# Type: Perl Script                                     /_.\
# By Fernando Gilli fernando<at>wekers(dot)org    _,.-'/ `",\'-.,_
# Last modified:2023-09-30                     -~^    /______\`~~-^~:
# ------------------------
# Get Moon data from perl module Astro::MoonPhase
# / OS : $Linux, $FreeBSD (X Window)
# -------------------------------------------------------------------


use warnings;
use strict;
use POSIX qw(strftime);

use Astro::MoonPhase;

open(my $fh, '<', 'moon_phase_die'); # open file
  my @list = <$fh>;
close $fh; # Close file


my $start = time();
my $stop = $start+30*24*60*60; # Now +30 days

my @name = ("New Moon", "First Quarter", "Full Moon", "Last Quarter");
(my $phase, my @times) = phaselist($start, $stop);
 
my $countFullMoon = 0;
my $countNewMoon = 0;

while (@times){

  my $timeNextPhase = scalar shift @times;

  if ($phase eq 2 and $countFullMoon eq 0) { # 2 = Full Moon
      
      $countFullMoon = 1; # to execute only one time
      
      my $days_left_full = int((($timeNextPhase - time()) ) / 24 / 60 / 60);
      my $hours_left_full = int((($timeNextPhase - time()) % 86400) / 3600);
      my $min_left_full = int((($timeNextPhase - time()) % 3600) / 60);
     
      # list to write on file
      $list[0] = "$name[$phase]\n";
            
      if($days_left_full eq 0 and $hours_left_full > 0){
	  $list[1] = "in $hours_left_full hr   \n";
      }
      elsif ($days_left_full eq 0 and $hours_left_full eq 0) {
	  $list[1] = "in $min_left_full m    \n";
      }
      elsif ($days_left_full > 0) {
	  $list[1] = ucfirst strftime("%b %d\n", localtime($timeNextPhase));
	  #print ucfirst strftime("%b %d %R", gmtime($timeNextPhase)), "\n"; #In GMT Time
      }
      
      #print "days left for full is: $days_left_full", "\n";
      #print "hour left for full is: $hours_left_full hrs", "\n";
      #print "min left for full is: $min_left_full m", "\n";
   
  }
    
  if ($phase eq 0 and $countNewMoon eq 0) { # 2 = Full Moon
      
      $countNewMoon = 1; # to execute only one time
      
      my $days_left_new = int((($timeNextPhase - time()) ) / 24 / 60 / 60);
      my $hours_left_new = int((($timeNextPhase - time()) % 86400) / 3600);
      my $min_left_new = int((($timeNextPhase - time()) % 3600) / 60);
     
      # list to write on file
      $list[2] = "$name[$phase]\n";
            
      if($days_left_new eq 0 and $hours_left_new > 0){
	  $list[3] = "in $hours_left_new hr   \n";
      }
      elsif ($days_left_new eq 0 and $hours_left_new eq 0) {
	  $list[3] = "in $min_left_new m    \n";
      }
      elsif ($days_left_new > 0) {
	  $list[3] = ucfirst strftime("%b %d\n", localtime($timeNextPhase));
	  #print ucfirst strftime("%b %d %R", gmtime($timeNextPhase)), "\n"; #In GMT Time
      }
      
      #print "days left for new is: $days_left_new", "\n";
      #print "hour left for new is: $hours_left_new hrs", "\n";
      #print "min left for new is: $min_left_new m", "\n";
 
  }

$phase = ($phase + 1) % 4;

open(my $fh, '>', 'moon_phase_die'); # open file
  print $fh @list; # print list on file
close $fh; # Close file

} # Close while

