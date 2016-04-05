#!/usr/bin/perl
use strict;
use warnings;

open I1, "<", "Info_ChinaFeces.txt";
open I2, "<", "CR_CYTB_aligned_revised_haplotype.txt";
open O, ">", "reserve_sample_count.txt";

my %geo_sam;
<I1>;
while (<I1>) {
	my @a = split /\t/;
	push @{$geo_sam{"$a[1]"}}, $a[0];
}
close I1;

my %sam_hap;
while (<I2>) {
	next unless s/^>//;
	chomp;
	my @a = split /\t/;
	my @b = split / /, $a[1];
	$sam_hap{$_} = $a[0] foreach @b;
}
close I2;

foreach my $a (sort keys %geo_sam) {
	my $tot_num;
	my %hap_num;
	foreach my $b (@{$geo_sam{$a}}) {
		next unless exists $sam_hap{$b};
		warn $b if $a eq "0";
		++$tot_num;
		++$hap_num{$sam_hap{$b}};
	}
	print O "$a\n\tSampleSize\t$tot_num\n";
	foreach (sort keys %hap_num) {
		print O "\t\t$_\t$hap_num{$_}\n";
	}
}
close O;
