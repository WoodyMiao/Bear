#!/usr/bin/perl
use strict;
use warnings;

my $in = shift;
my $out = shift;
open I, "<", $in;
open O, ">", $out;

my %fasta;
while (<I>) {
	s/^>//;
	$/ = ">";
	my $seq = <I>;
	chomp $seq;
	$seq =~ s/\s//g;
	$/ = "\n";
	my $id;
	if (/^(?:Olga)?(\d+)/) {
		$id = sprintf "Olga%03d", $1;
	} elsif (/^(STH|UT)(\d+)/) {
		$id = sprintf "$1%03d", $2;
	} elsif (/^[Ss](\d+)/) {
		$id = sprintf "S%03d", $1;
	}else {
		warn $_;
	}
	push @{$fasta{$id}}, $seq;
}
close I;

foreach my $a (sort keys %fasta) {
	foreach (@{$fasta{$a}}) {
		print O ">$a\n$_\n";
	}
}
close O;
