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

my (@numMin, @numTang, @numWang, @numXue);
while (<I>) {
	chomp;
	my @a = split /\t/;
	if ($a[23] eq "Minshan") {
		my @b = split /,/, $a[25];
		my $c = @b;
		push @numMin, $c;
		if ($a[24] eq "Tangjiahe") {
			push @numTang, $c;
		} elsif ($a[24] eq "Wanglang") {
			push @numWang, $c;
		} elsif ($a[24] eq "Xuebaoding") {
			push @numXue, $c;
		}
	}
}
close I;

my (%numMin, %numTang, %numWang, %numXue);
++$numMin{$_} foreach @numMin;
++$numTang{$_} foreach @numTang;
++$numWang{$_} foreach @numWang;
++$numXue{$_} foreach @numXue;

print O1 "$_\t$numMin{$_}\n" foreach sort {$a <=> $b} keys %numMin;
close O1;

print O2 "$_\t$numTang{$_}\n" foreach sort {$a <=> $b} keys %numTang;
close O2;

print O3 "$_\t$numWang{$_}\n" foreach sort {$a <=> $b} keys %numWang;
close O3;

print O4 "$_\t$numXue{$_}\n" foreach sort {$a <=> $b} keys %numXue;
close O4;
