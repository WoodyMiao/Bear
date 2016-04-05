#!/usr/bin/perl
use strict;
use warnings;

while (<>) {
  chomp;
  my @a = split /\t/;
  splice @a, 21, 2;
  splice @a, 11, 2;
  splice @a, 7, 2;
  splice @a, 3, 2;
  print join "\t", @a;
  print "\n";
}
