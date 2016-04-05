#!/usr/bin/perl
use strict;
use warnings;

open I, "<", "mt_STR_indiv_consensus.txt";
open O, ">", "mt_seq_length.txt";

while (<I>) {
	if (/^(?:Indiv|Olga)\d{3}/) {
		chomp;
		my @a = split /\t/;
		my $crlen = 0;
		my $cblen = 0;
		$crlen = @{[$a[-2] =~ m/A|T|C|G/g]} if $a[-2];
		$cblen = @{[$a[-1] =~ m/A|T|C|G/g]} if $a[-1];
		print O "$a[0]\t$crlen\t$cblen\n";
	} else {
		next;
	}
}
close I;
close O;
