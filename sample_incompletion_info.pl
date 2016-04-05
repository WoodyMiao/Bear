#!/usr/bin/perl
use strict;
use warnings;

open I, "<", "Info_ChinaFeces.txt";
open O, ">", "sample_incompletion_info.txt";

my $a = <I>;
print O $a;

while (<I>) {
	chomp;
	my @b = split /\t/;
	my $c = grep(/^0/, @b);
	if ($c) {
		print O "$_\n";
	}
}

close I;
close O;
