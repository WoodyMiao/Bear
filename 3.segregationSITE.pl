#!/usr/bin/perl
use strict;
use warnings;

my $in = shift;
my $out = shift;
open I, "<", $in;
open O, ">", $out;

my $refname = <I>;
my $refseq = <I>;

print O $refname, $refseq;

chomp $refseq;
my $l = length $refseq;

while (<I>) {
	print O $_;
	my $seq = <I>;
	chomp $seq;
	foreach (0 .. $l-1) {
		if (substr($seq, $_, 1) eq substr($refseq, $_, 1)) {
			print O ".";
		} else {
			print O substr($seq, $_, 1);
		}
	}
	print O "\n";
}
close I;
close O;
