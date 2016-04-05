#!/usr/bin/perl
use strict;
use warnings;

$_ = <>;
s/\tRepeat//;
print $_;

while (<>) {
  if (s/\tfinal//) {
    print $_;
  } else {
    next;
  }
}
