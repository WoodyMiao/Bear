#!/usr/bin/perl
use strict;
use warnings;

open I1, "<", "22_Russia_106_China_8_loci.txt";
open I2, "<", "CR_all_available_haplotype_sample.txt";
open I3, "<", "CR_CYTB_all_available_haplotype_sample.txt";
open I4, "<", "sample_info.txt";

my %sample;
while (<I1>) {
	chomp;
	my @a = split /\t/;
	my @b = split /,/, $a[-1];
	foreach (@b) {
		$sample{$_}[2] = $a[-3];
		$sample{$_}[3] = $a[-2];
		$sample{$_}[4] = $a[0];
		$sample{$_}[10] = $a[-1];
	}
}
close I1;

while (<I2>) {
	chomp;
	my @a = split /\t/;
	my @b = split /,/, $a[-1];
	foreach (@b) {
		if ($_ =~ /^KARS|OLGA|CT|UT|STH/) {
			$sample{$_}[5] = $a[0];
		}
	}
}
close I2;

while (<I3>) {
	chomp;
	my @a = split /\t/;
	my @b = split / /, $a[-1];
	foreach (@b) {
		if ($_ =~ /^KARS|OLGA|CT|UT|STH/) {
			$sample{$_}[6] = $a[0];
		}
	}
}
close I3;

while (<I4>) {
	chomp;
	my @a = split /\t/;
	if ($a[0] =~ /^RFEB/ and $a[4] =~ /^\d+/) {
		my $b = sprintf("OLGA%04d", $a[4]);
		$sample{$b}[0] = $a[0];
		$sample{$b}[1] = $b;
		$sample{$b}[7] = $a[3];
		$sample{$b}[8] = $a[5];
		$sample{$b}[9] = $a[6];
	} elsif ($a[0] =~ /^RFEB/ and $a[4] =~ /^UT/) {
		$sample{$a[4]}[0] = $a[0];
		$sample{$a[4]}[1] = $a[4];
		$sample{$a[4]}[7] = $a[3];
		$sample{$a[4]}[8] = $a[5];
		$sample{$a[4]}[9] = $a[6];
	} else {
		$sample{$a[0]}[0] = $a[0];
		$sample{$a[0]}[1] = $a[4];
		$sample{$a[0]}[7] = $a[3];
		$sample{$a[0]}[8] = $a[5];
		$sample{$a[0]}[9] = $a[6];
	}

}
close I4;

open O, ">", "sample_table.txt";
foreach my $a (sort keys %sample) {
	if ($sample{$a}[5] or $sample{$a}[6] or $sample{$a}[10]){
		print O "$a\t";
		foreach my $b (0..9) {
			if ($sample{$a}[$b]) {
				print O "$sample{$a}[$b]\t";
			} else {
				print O "n/a\t";
			}
		}
		if ($sample{$a}[10]){
			print O "$sample{$a}[10]\n";
		} else {
			print O "n/a\n";
		}
	}
}
close O;
