#!/usr/bin/perl
use strict;
use warnings;

open I1, "<", "CR_aligned_revised_haplotype.txt";
open I2, "<", "Info_ChinaFeces.txt";
open I3, "<", "CR_Info_GenBankSeq.txt";
open O, ">", "CR_haplotype_geo_info.txt";

my %hap_sam;
while (<I1>) {
	next unless /^>/;
	chomp;
	my @a = split /\t/;
	my @b = split / /, $a[1];
	$a[0] =~ s/^>//;
	$hap_sam{$a[0]} = \@b;
}
close I1;

my %sam_geo;
<I2>;
while (<I2>) {
	my @a = split /\t/;
	$sam_geo{$a[0]} = $a[1];
}
close I2;

<I3>;
while (<I3>) {
	chomp;
	my @a = split /\t/;
	$sam_geo{$a[-1]} = $a[1];
}
close I3;

my %hap_geo;
foreach my $a (keys %hap_sam) {
	my %g;
	foreach my $b (@{$hap_sam{$a}}) {
		if ($b =~ /(?:gb|dbj)\|(\w+)\.1\|$/) {
			$b = $1;
		}
		$g{$sam_geo{$b}} = 1 if exists $sam_geo{$b};
	}
	foreach my $c (keys %g) {
		$hap_geo{$a} .= "_$c" if $c;
	}
}

foreach (sort keys %hap_sam) {
	if (exists $hap_geo{$_}) {
		print O "$_\t$hap_geo{$_}\n";
	} else {
		if ($hap_sam{$_}[0] =~ /^KARB/) {
			print O "$_\t_Bear_farm\n";
		} elsif ($hap_sam{$_}[0] =~ /^OLGA/) {
			print O "$_\t_Russian_confiscated\n";
		} elsif ($hap_sam{$_}[0] =~ /^UT|STH/) {
			print O "$_\t_Russian_wild\n";
		} else {
			warn $_;
		}
	}
}
close O;
