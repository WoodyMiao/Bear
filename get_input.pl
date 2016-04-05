#!/usr/bin/perl
use strict;
use warnings;

while (<>) {
  s/\t\r//;
  s/\r//;
  if (/^Sample/) {
    print $_;
  } elsif (/^S181/) {
    print "KARS$_";
  } else {
    print "KARS0$_";
  }
}
