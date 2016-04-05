#!/usr/bin/perl
use strict;
use warnings;

my $in = shift;

open I, "<", $in;
open O, ">>", "KARSmt.fasta";
$in =~ /(KARS\d{4})/;
my $sample = $1;

while (<I>) {
	next if /^@/;
	my @a = split /\t/;
	print O ">$sample\n$a[9]\n";
}

close I;
close O;
