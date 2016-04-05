#!/usr/bin/perl
use strict;
use warnings;

while (<>) {
	my @a = split /\t/;
	splice @a, 10;
	splice @a, 2, 6;
	splice @a, 0, 1;
	print join "\t", @a;
	print "\r\n";
}
