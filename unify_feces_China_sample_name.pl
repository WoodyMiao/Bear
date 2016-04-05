#!/usr/bin/perl
use strict;
use warnings;

my $in = shift;
my $out = shift;
open I, "<", $in;
open O, ">", $out;

my %fasta;
while (<I>) {
	my $name = ">$_";
	$/ = ">";
	my $seq = <I>;
	chomp $seq;
	$seq =~ s/\s//g;
	$/ = "\n";
	my @a = $name =~ m/\D\d{3}\D/g;
	my $id = "no";
	if (@a == 0) {
		if (/(KARS0\d{3})/) {
			$id = $1;
		} else {
			warn $name;
		}
	} elsif (@a == 1) {
		$a[0] =~ s/\D//g;
		$id = "KARS0$a[0]";
	} else {
		warn $name;
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
