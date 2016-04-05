#!/usr/bin/perl
use strict;
use warnings;

open I1, "<", "../mt_STR_indiv_consensus.txt";
open I2, "<", "../indiv_redundant_mt_seq.txt";
open O1, ">", "concatenated_mt.txt";
open O2, ">", "redundant_CytB_seq.txt";

my %cb;
my %cr;
<I1>;
<I1>;
my $indiv = <I1>;
while ($indiv =~ m/^Indiv\d/) {
	chomp $indiv;
	my @a = split /\t/, $indiv;
	my $sample = <I1>;
	while ($sample =~ m/^\w/) {
		my @b = split /\t/, $sample;
		$cb{$b[0]} = $a[-1] if $a[-1];
		$cr{$b[0]} = $a[-2] if $a[-2];
		$sample = <I1>;
	}
	$indiv = <I1>;
}
while (<I1>) {
	chomp;
	my @a = split /\t/;
	$cb{$a[0]} = $a[-1] if $a[-1];
	$cr{$a[0]} = $a[-2] if $a[-2];
}
close I1;

<I2>;
my $sample = <I2>;
while ($sample =~ m/^\w/) {
	chomp $sample;
	my @a = split /\t/, $sample;
	$cr{$a[0]} = $a[1];
	$sample = <I2>;
}
while (<I2>) {
	next unless /^\w/;
	chomp;
	my @a = split /\t/;
	$cb{$a[0]} = $a[1];
}
close I2;

foreach (sort keys %cr) {
	if ($cb{$_}) {
		$cb{$_} =~ s/-/N/g;
		print O1 ">$_\n$cr{$_}$cb{$_}\n";
	} else {
		print O1 ">$_\n$cr{$_}", ("N" x 1140), "\n";
	}
}
close O1;

foreach (sort keys %cb) {
	$cb{$_} =~ s/-/N/g;
	print O2 ">$_\n$cb{$_}\n" unless $cr{$_};
}
close O2;
