#!/usr/bin/perl
use strict;
use warnings;

open I, "-|", "cat sequencher_aligned/*";
open O, ">", "CR_14.fasta";

while (<I>) {
	chomp;
	s/>//;
	$/ = ">";
	my $seq = <I>;
	chomp $seq;
	$seq =~ s/\n//g;
	$seq =~ s/:/-/g;
	$/ = "\n";
	print O ">$_\n$seq\n";
}

close I;
close O;
