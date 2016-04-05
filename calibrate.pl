#!/usr/bin/perl
use strict;
use warnings;

while (<>) {
	s/\r//;
	if (/^#/) {
		s/\t$//;
		print $_;
	} else {
		chomp;
		my @a = split /\t/;
		$a[1] += 1 if $a[1];
		$a[2] += 1 if $a[2];
		$a[3] += 1 if $a[3];
		$a[4] += 1 if $a[4];
		$a[15] += 1 if $a[15];
		$a[16] += 1 if $a[16];
		$a[19] += 2 if $a[19];
		$a[20] += 2 if $a[20];
		$a[21] += 1 if $a[21];
		$a[22] += 1 if $a[22];
		print join "\t", @a;
		print "\n";
	}
}
