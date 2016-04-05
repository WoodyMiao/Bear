#!/usr/bin/perl
use strict;
use warnings;

my $in = shift;
my $out = shift;
open I, "<", $in;
open O, ">", $out;

my %input; # input sequences
while (<I>) {
	$/ = ">";
	my $seq = <I>;
	chomp $seq;
	$seq =~ s/\s//g;
	$/ = "\n";
	s/>//;
	/^(\S+)\s/;
	$input{$1} = $seq;
}
close I;

my %protein;
push @{$protein{$input{$_}}}, $_ foreach sort keys %input;
print O ">", join("|", @{$protein{$_}}), "\n$_\n" foreach sort keys %protein;
close O;
