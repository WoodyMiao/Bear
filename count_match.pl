#!/usr/bin/perl
use strict;
use warnings;

my $in = shift;
open I, "<", $in;
open O, ">>", "count_match.txt";
$in =~ /(KARS\d{4})/;
my $sample = $1;
my $m;
while (<I>) {
	next if /^@/;
	my @a = split /\t/;
	my @b = @{[$a[5] =~ /\d+M/g]};
	foreach (@b) {
		s/M//;
		$m += $_;
	}
}
print O "$sample\t$m\n";
close I;
close O;
