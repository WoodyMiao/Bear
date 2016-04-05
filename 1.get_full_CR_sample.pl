#!/usr/bin/perl
use strict;
use warnings;

open I, "-|", "cat /share/users/miaolin/4.Bear/8.mt_sample_consensus/CR_Thailand.txt /share/users/miaolin/4.Bear/8.mt_sample_consensus/CR_sample.txt";
open O, ">", "full_CR.fasta";

while (<I>) {
	my $seq = <I>;
	next if /KARB/;
	next if $seq =~ /N/;
	$seq =~ s/-//g;
	print O $_, $seq;
}
close I;
close O;
