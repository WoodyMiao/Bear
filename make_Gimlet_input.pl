#!/usr/bin/perl
use strict;
use warnings;

open I, "<", "China_feces_STR_genotype_8loci_final_geo.txt";
open O1, ">", "input_Minshan.txt";
open O2, ">", "input_Tangjiahe.txt";
open O3, ">", "input_Wanglang.txt";
open O4, ">", "input_Xuebaoding.txt";

my $title = <I>;
chomp $title;
my @title = split /\t/, $title;
my @loci;
foreach (@title) {
	if (/^[ABDG]/) {
		push @loci, $_;
	}
}

my (%samMin, %samTang, %samWang, %samXue);
while (<I>) {
	chomp;
	my @a = split /\t/;
	if ($a[23] eq "Minshan") {
		my @b = split /,/, $a[25];
		my $gt;
		for (my $i = 1; $i < 22; $i += 2) {
			$gt .= sprintf(" %03d%03d", $a[$i], $a[$i+1]);
		}
		foreach (@b) {
			$samMin{$_} = $gt;
		}
		if ($a[24] eq "Tangjiahe") {
			$samTang{$_} = $gt foreach @b;
		} elsif ($a[24] eq "Wanglang") {
			$samWang{$_} = $gt foreach @b;
		} elsif ($a[24] eq "Xuebaoding") {
			$samXue{$_} = $gt foreach @b;
		}
	}
}
close I;

print O1 "Minshan Feces Sample STR Genotype (GenePop Format)\r\n";
print O1 "$_\r\n" foreach @loci;
print O1 "POP\r\n";
print O1 "$_,$samMin{$_}\r\n" foreach sort keys %samMin;
close O1;

print O2 "Tangjiahe Feces Sample STR Genotype (GenePop Format)\r\n";
print O2 "$_\r\n" foreach @loci;
print O2 "POP\r\n";
print O2 "$_,$samTang{$_}\r\n" foreach sort keys %samTang;
close O2;

print O3 "Wanglang Feces Sample STR Genotype (GenePop Format)\r\n";
print O3 "$_\r\n" foreach @loci;
print O3 "POP\r\n";
print O3 "$_,$samWang{$_}\r\n" foreach sort keys %samWang;
close O3;

print O4 "Xuebaoding Feces Sample STR Genotype (GenePop Format)\r\n";
print O4 "$_\r\n" foreach @loci;
print O4 "POP\r\n";
print O4 "$_,$samXue{$_}\r\n" foreach sort keys %samXue;
close O4;
