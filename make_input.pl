#!/usr/bin/perl
use strict;
use warnings;

open I, "<", "20_Russia_all_China_8_loci.txt";
open O1, ">", "Tangjiahe_indiv.inp";
open O2, ">", "Tangjiahe_freq.inp";

my %indiv;
while (<I>) {
	chomp;
	my @a = split /\t/;
	next unless $a[-2] eq "Tangjiahe";
	my @b = split /,/, $a[-1];
	my $c = 0;
	foreach (@b) {
		/(\d{3})$/;
		if ($1 >= 1 and $1 <= 216) {
			$c |= 4;
		} elsif ($1 >=217 and $1 <= 552) {
			$c |= 2;
		} elsif ($1 >=553 and $1 <= 823) {
			$c |= 1;
		} else {
			warn $_;
		}
	}
	$indiv{$a[0]} = $c;
}
close I;

my %freq;
foreach (sort keys %indiv) {
	my $d = sprintf("%03b", $indiv{$_});
	print O1 "/*$_*/\t$d\t1;\r\n";
	++$freq{"$d"};
}
close O1;

foreach (sort keys %freq) {
	print O2 "$_\t$freq{$_};\r\n";
}
close O2;
