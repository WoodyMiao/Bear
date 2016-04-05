#!/usr/bin/perl
use strict;
use warnings;

open I, "<", "../CR_CYTB_BSP_combined.log";
open O, ">", "posterior_likelihood.txt";

while (<I>) {
	chomp;
	my @a = split /\t/;
	if ($a[0] =~ /state|000000$/) {
		print O "$a[0]\t$a[1]\t$a[2]\t$a[3]\n";
	}
}

close I;
close O;
