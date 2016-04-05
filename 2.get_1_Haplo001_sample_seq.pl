#!/usr/bin/perl
use strict;
use warnings;

open I1, "<", "../CR_14.fasta";
my %KoreaCR;
while (<I1>) {
	my $seq = <I1>;
	chomp $seq;
	$KoreaCR{$1} = $seq if /^>(\w+)_Korea/;
}
close I1;

open I2, "<", "../../7.HaploID_full_CYTB/CYTB_GenBank.fasta";
my %KoreaCY;
while (<I2>) {
	my $seq = <I2>;
	chomp $seq;
	$KoreaCY{$1} = $seq if /^>(\w+)_North_Korea/;
}
close I2;

open O, ">", "Haplo001_sample.fasta";
print O ">EF667005_EF667005\n$KoreaCR{EF667005}$KoreaCY{EF667005}\n";
print O ">EU573178_EU573172\n$KoreaCR{EU573178}$KoreaCY{EU573172}\n";
print O ">EU573180_EU573174\n$KoreaCR{EU573180}$KoreaCY{EU573174}\n";
print O ">EU573182_EU573176\n$KoreaCR{EU573182}$KoreaCY{EU573176}\n";

open I3, "<", "../full_CR_sample.fasta";
my %ChinaCR;
while (<I3>) {
	my $seq = <I3>;
	chomp $seq;
	$ChinaCR{$1} = $seq if /^>(KARS\d+)/;
}
close I3;

open I4, "<", "../../7.HaploID_full_CYTB/full_CYTB.fasta";
my %ChinaCY;
while (<I4>) {
	my $seq = <I4>;
	chomp $seq;
	$ChinaCY{$1} = $seq if /^>(KARS\d+)/;
}
close I4;

open I5, "<", "../full_CR_haplotype.txt";
my @China;
while (<I5>) {
	if (/Haplo002/) {
		chomp;
		my @a = split /\t/;
		@China = split / /, $a[1];
		last;
	}
}
close I5;

foreach (@China) {
	print O ">$_\n$ChinaCR{$_}$ChinaCY{$_}\n" if exists $ChinaCY{$_};
}
close O;
