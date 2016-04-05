#!/usr/bin/perl
use strict;
use warnings;

open I1, "<", "../c.Clustal/2.CR_CYTB/CR_CYTB_aligned_revised_2nd_haplotype.txt";
open I2, "<", "../i.Structure/4.feces_China_genotype_to_Karl/China_feces_STR_genotype_8loci_final.txt";
open I3, "<", "../b.STR_mtDNA_final/Info_ChinaFeces.txt";
open O1, ">", "mt_sample_info.txt";
open O2, ">", "STR_sample_info.txt";

my @mt;
while (<I1>) {
	next unless /^>/;
	chomp;
	my @a = split /\t/;
	my @b = split / /, $a[1];
	foreach (@b) {
		push @mt, $_ if /^KARS/;
	}
}
close I1;

<I2>;
my @STR;
while (<I2>) {
	chomp;
	my @a = split /\t/;
	my @b = split /,/, $a[-1];
	push @STR, @b;
}
close I2;

<I3>;
my %sam_geo;
while (<I3>) {
	my @a = split /\t/;
	$sam_geo{$a[0]} = $_;
}
close I3;

foreach (sort @mt) {
	print O1 $sam_geo{$_};
}
close O1;

foreach (sort @STR) {
	if ($sam_geo{$_}) {
		print O2 $sam_geo{$_};
	} else {
		warn $_;
	}
}
close O2;
