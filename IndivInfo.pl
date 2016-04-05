#!/usr/bin/perl
use strict;
use warnings;

open I1, "<", "Indiv_black_bear.txt";
open I2, "<", "sample_information.txt";
open O, ">", "Indiv_black_bear_info.txt";

my %info;
while (<I2>) {
	my @a = split /\t/;
	my $b = shift @a;
	$info{$b} = join "\t", @a;
}

while (<I1>) {
	my @a = split /\t/;
	my $b = shift @a;
	if ($b =~ /^KARS/) {
		print O "$b\t$info{$b}";
	} else {
		print O "$b\n";
	}
}

close I1;
close I2;
close O;

