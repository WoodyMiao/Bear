#!/usr/bin/perl
use strict;
use warnings;

open I, "<", "black_bear_mt_haplotype.txt";
open O, ">", "black_bear_mt_haplotype_full_length.txt";

#my $n = 1;
while (<I>) {
#	my @a = split /\t/;
	my $seq = <I>;
	if (@{[$seq =~ /N|\?/]} == 0) {
		print O $_, $seq;
#		$seq =~ s/-CCCCCC/CCCCCC/;
#		print O sprintf(">Haplo%03d\t", $n), $a[1], $seq;
#		++$n;
	}
}

close I;
close O;
