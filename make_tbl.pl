#!/usr/bin/perl
use strict;
use warnings;

open I, "<", "KARS0101_annotation.gb";
open O, ">", "KARS0101.tbl";

while (<I>) {
	last if /^FEATURES/;
}

print O ">Feature KARS0101\n";

while (<I>) {
	last if /^ORIGIN/;
	chomp;
	if (s/^[ ]+\///) {
		s/"//g;
		my @a = split /=/;
		print O "\t\t\t$a[0]\t$a[1]\n";
	} else {
		if (/complement/) {
			/^\s+([-A-Za-z]+)\s+complement\((\d+)\.\.(\d+)\)$/;
			print O "$3\t$2\t$1\n";
		} else {
			/^\s+([-_A-Za-z]+)\s+(\d+)\.\.(\d+)$/;
			print O "$2\t$3\t$1\n";
		}
	}
}

close I;
close O;
