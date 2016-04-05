#!/usr/bin/perl
use strict;
use warnings;

open I1, "<", "CR_GenBank.TXT";
open I2, "<", "CYTB_GenBank.TXT";
open O, ">", "CR_CYTB_NCBI.fasta";

my %cr;
while (<I1>) {
	chomp;
	s/>//;
	$/ = ">";
	my $seq = <I1>;
	chomp $seq;
	$seq =~ s/\s//g;
	$/ = "\n";
	/^gi\|\d+\|\w+\|(\w+)\./;
	$cr{$1} = $seq;
}
close I1;

my %cb;
while (<I2>) {
	chomp;
	s/>//;
	$/ = ">";
	my $seq = <I2>;
	chomp $seq;
	$seq =~ s/\s//g;
	$/ = "\n";
	/^gi\|\d+\|\w+\|(\w+)\./;
	$cb{$1} = $seq;
}
close I2;

my %id = (
Rangrim33	=>	[qw/EU573177 EU573171/],
Songwon43	=>	[qw/EU573178 EU573172/],
Songwon9	=>	[qw/EU573179 EU573173/],
Jangkang21	=>	[qw/EU573180 EU573174/],
Jangkang24	=>	[qw/EU573181 EU573175/],
Duksung16	=>	[qw/EU573182 EU573176/],
Duksung17	=>	[qw/EF667005 EF667005/],
J1	=>	[qw/AB360915 AB360959/],
J2	=>	[qw/AB360916 AB360960/],
J4	=>	[qw/AB360919 AB360962/],
J6	=>	[qw/AB360923 AB360964/],
NC_011117	=>	[qw/NC_011117 NC_011117/],
NC_009331	=>	[qw/NC_009331 NC_009331/],
NC_008753	=>	[qw/NC_008753 NC_008753/],
NC_009968	=>	[qw/NC_009968 NC_009968/],
NC_003426	=>	[qw/NC_003426 NC_003426/],
NC_003427	=>	[qw/NC_003427 NC_003427/],
NC_003428	=>	[qw/NC_003428 NC_003428/],
);

foreach (sort keys %id) {
	print O ">$_\n$cr{${$id{$_}}[0]}$cb{${$id{$_}}[1]}\n";
}

close O;
