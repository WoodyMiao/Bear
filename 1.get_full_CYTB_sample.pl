#!/usr/bin/perl
use strict;
use warnings;

open I, "-|", "cat /share/users/miaolin/4.Bear/8.mt_sample_consensus/CytB_Thailand.txt /share/users/miaolin/4.Bear/8.mt_sample_consensus/CytB_sample.txt";
open O, ">", "full_CYTB.fasta";

while (<I>) {
	my $seq = <I>;
	next if /KARB/;
	next if $seq =~ /N/;
	print O $_, $seq;
}
close I;
close O;
