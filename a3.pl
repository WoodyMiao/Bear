#!/usr/bin/perl
use strict;
use warnings;

open I1, "<", "China_CR_consensus.error.txt";
open O1, ">", "c.log";

my %cr;
while (<I1>) {
	if (/^#/ or /^\n/) {
		print O1 $_;
		warn $_;
		next;
	}
	print O1 $_;
	chomp;
	s/>//;
	$/ = ">";
	my $seq = <I1>;
	chomp $seq;
	$seq =~ s/\s//g;
	$/ = "\n";
	$cr{$_} = $seq;
}
close I1;
close O1;
