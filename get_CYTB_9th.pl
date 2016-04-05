#!/usr/bin/perl
use strict;
use warnings;

open I, "<", "CR_CYTB_aligned_revised_8th_haplotype.nex";
open O, ">", "CYTB_9th.nex";

while (<I>) {
	if (/^#|^Matrix/ or /;$/) {
		print O $_;
	} else {
		my @a = split /\t/;
		substr($a[1], 0, 236, "");
		print O "$a[0]\t$a[1]";
	}
}
close I;
close O;
