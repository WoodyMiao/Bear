#!/usr/bin/perl
use strict;
use warnings;

open I1, "<", "../b.HaploID_full_CR/CR_14.fasta";
my %bankCR;
while (<I1>) {
	my $seq = <I1>;
	chomp $seq;
	$seq =~ s/-//g;
	$bankCR{$1} = $seq if /^>(\w+)_(Korea|Japan)/;
}
close I1;

open I11, "<", "../b.HaploID_full_CR/CR_17.fasta";
while (<I11>) {
	my $seq = <I11>;
	chomp $seq;
	$seq =~ s/-//g;
	$bankCR{$1} = $seq if /^>(NC_\d+)/;
}
close I11;

open I2, "<", "../a.HaploID_full_CYTB/CYTB_14.fasta";
my %bankCY;
while (<I2>) {
	my $seq = <I2>;
	chomp $seq;
	$bankCY{$1} = $seq if /^>((NC_|AB|EF|EU)\d+)/;
}
close I2;

open O, ">", "full_CR_CYTB_sample.fasta";
print O ">AB360915_AB360959\n$bankCR{AB360915}$bankCY{AB360959}\n";
print O ">EF667005\n$bankCR{EF667005}$bankCY{EF667005}\n";
print O ">EU573177_EU573171\n$bankCR{EU573177}$bankCY{EU573171}\n";
print O ">EU573178_EU573172\n$bankCR{EU573178}$bankCY{EU573172}\n";
print O ">EU573179_EU573173\n$bankCR{EU573179}$bankCY{EU573173}\n";
print O ">EU573180_EU573174\n$bankCR{EU573180}$bankCY{EU573174}\n";
print O ">EU573181_EU573175\n$bankCR{EU573181}$bankCY{EU573175}\n";
print O ">NC_011117\n$bankCR{NC_011117}$bankCY{NC_011117}\n";
print O ">NC_011118\n$bankCR{NC_011118}$bankCY{NC_011118}\n";
print O ">NC_009331\n$bankCR{NC_009331}$bankCY{NC_009331}\n";

open I3, "<", "../b.HaploID_full_CR/full_CR_sample.fasta";
my %ChinaCR;
while (<I3>) {
	my $seq = <I3>;
	chomp $seq;
	$ChinaCR{$1} = $seq if /^>(\w+)/;
}
close I3;

open I4, "<", "../a.HaploID_full_CYTB/full_CYTB.fasta";
my %ChinaCY;
while (<I4>) {
	my $seq = <I4>;
	chomp $seq;
	$ChinaCY{$1} = $seq if /^>(\w+)/;
}
close I4;

foreach (sort keys %ChinaCR) {
	print O ">$_\n$ChinaCR{$_}$ChinaCY{$_}\n" if exists $ChinaCY{$_};
}
close O;
