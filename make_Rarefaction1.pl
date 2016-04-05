#!/usr/bin/perl
use strict;
use warnings;

open I, "<", "China_feces_STR_genotype_8loci_final_geo.txt";
open O1, ">", "Rarefaction1_Minshan.txt";
open O2, ">", "Rarefaction1_Tangjiahe.txt";
open O3, ">", "Rarefaction1_Wanglang.txt";
open O4, ">", "Rarefaction1_Xuebaoding.txt";

while (<I>) {
	chomp;
	my @a = split /\t/;
	if ($a[23] eq "Minshan") {
		my @b = split /,/, $a[25];
		my $c = @b;
		print O1 "$c\r\n";
		if ($a[24] eq "Tangjiahe") {
			print O2 "$c\r\n";
		} elsif ($a[24] eq "Wanglang") {
			print O3 "$c\r\n";
		} elsif ($a[24] eq "Xuebaoding") {
			print O4 "$c\r\n";
		}
	}
}
close I;

close O1;

close O2;

close O3;

close O4;
