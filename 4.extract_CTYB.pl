#!/usr/bin/perl
use strict;
use warnings;

open I, "<", "Haplo001_haplotype_geo.fasta";
open O, ">", "Haplo001_haplotype_geo_CYTB.fasta";

while (<I>) {
	print O $_;
	my $seq = <I>;
	chomp $seq;
	my $cytb = substr $seq, -1140;
	print O $cytb, "\n";
}
close I;
close O;
