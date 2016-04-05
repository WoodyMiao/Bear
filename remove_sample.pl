#!/usr/bin/perl
use strict;
use warnings;

my $at_least = shift;
my $out_put = shift;
open I, "<", "concatenated_mt.txt";
open O, ">", $out_put;

while (<I>) {
	chomp;
	my @a = split /\t/;
	my $bp =  @{[$a[2] =~ /[ATCG]/g]};
	print O "$_\n" if $bp >= $at_least;
}
close I;
close O;
