#!/usr/bin/perl
use strict;
use warnings;

open I1, "<", "CR_CYTB_aligned_revised_2nd_haplotype.txt";
open I2, "<", "all_sample_count.txt";
open O1, ">", "all_sample_arlequin_input.txt";

my %hap_seq;
while (<I1>) {
	s/^>//;
	my @a = split /\t/;
	$hap_seq{$a[0]} = <I1>;
}
close I1;

my @haplotype;
while (<I2>) {
	if (/(Haplo\d{3})/) {
		push @haplotype, $1;
	} else {
		next;
	}
}
close I2;

foreach (sort @haplotype) {
	print O1 "\t\t$_\t$hap_seq{$_}";
}
close O1;
