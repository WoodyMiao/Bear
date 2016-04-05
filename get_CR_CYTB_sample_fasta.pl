#!/usr/bin/perl
use strict;
use warnings;

open I, "<", "../a.mt_hyplotype/5.samples_have_1100bp_CytB/concatenated_mt_with_1100bp_CytB.txt";
open O, ">", "CR_CYTB_sample.fasta";

while (<I>) {
	s/\r//g;
	s/\-//g;
	my @a = split /\t/;
	print O ">$a[0]\n$a[1]$a[2]";
}

close I;
close O;
