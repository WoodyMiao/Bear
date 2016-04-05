#!/usr/bin/perl
use strict;
use warnings;

my $in = shift;
open I, "<", $in;
open O, ">>", "depth_distribution.txt";

<I>;
my @depth;
while (<I>) {
	chomp;
	my @a = split /,/;
	$depth[$a[1]] += 1;
}

print O "$in\n";
foreach (0 .. @depth) {
	$depth[$_] = 0 unless $depth[$_];
	print O "$_\t$depth[$_]\n";
}




close I;
close O;
