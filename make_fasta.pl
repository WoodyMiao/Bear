#!/usr/bin/perl
use strict;
use warnings;

open I, "<", "KARS0101_annotation.gb";
open O, ">", "KARS0101.fasta";

while (<I>) {
	last if /^ORIGIN/;
}

my $seq;
while (<I>) {
	last if /^\//;
	$seq .= $_;
}
close I;

$seq =~ s/\s//g;
$seq =~ s/\d//g;

print O ">KARS0101 [organism=Ursus thibetanus] [location=mitochondrion] [mgcode=2] Ursus thibetanus, mitochondrial, complete genome\n$seq\n";
close O;
