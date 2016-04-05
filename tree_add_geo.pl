#!/usr/bin/perl
use strict;
use warnings;

open "I0", "<", "haplotype_geo_info.txt";
open "I", "<", "CR_CYTB_aligned_revised_haplotype.nex.con.tre";
open "O", ">", "CR_CYTB_aligned_revised_haplotype.nex.con.geo.tre";

my %hap_geo;
while (<I0>) {
	chomp;
	my @a = split /\t/;
	$hap_geo{$a[0]} = $a[1];
}
close I0;

while (<I>) {
	if (/Haplo\d{3}/) {
		s/(Haplo\d{3})/$1$hap_geo{$1}/;
	}
	print O $_;
}

close I;
close O;
