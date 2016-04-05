#!/usr/bin/perl
use strict;
use warnings;

open I, "<", "concatenated_mt.txt";
open O, ">", "concatenated_mt_CytB_bp.log";

my %bp;
while (<I>) {
	chomp;
	my @a = split /\t/;
	$bp{$a[0]} = @{[$a[2] =~ /[ATCG]/g]};
}
close I;

print O "#Sample ID\tCytB bp\n";
my %n;
foreach (sort {$bp{$b} <=> $bp{$a}} keys %bp ) {
	print O "$_\t$bp{$_}\n";
	++$n{$bp{$_}};
}

print O "No. bp\tNo. samples\n";
foreach (sort {$b <=> $a} keys %n) {
	print O "$_\t$n{$_}\n";
}
close O;
