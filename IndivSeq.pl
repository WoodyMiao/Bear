#!/usr/bin/perl
use strict;
use warnings;

open I1, "<", "20_Russia_all_China_8_loci.txt";
open I2, "<", "CR_CYTB_STRInfo_24.txt";
open O1, ">", "IndivSeq_CR_CYTB_24.fasta";
open O2, ">", "Individual_STR_8loci_mtHap_CR_CYTB_24.txt";

my %sam_hap;
my %hap_seq;
while (<I2>) {
	next unless /Haplo/;
	my $seq = <I2>;
	chomp;
	chomp $seq;
	s/>//;
	my @a = split /\t/;
	my @b = split / /, $a[1];
	foreach (@b) {
		$sam_hap{$_} = $a[0];
	}
	$hap_seq{$a[0]} = $seq;
}
close I2;

my $title = <I1>;
$title =~ s/\r//;
print O2 $title;

while (<I1>) {
	s/\r\n//;
	my @a = split /\t/;
	my @b = split /,/, $a[27];
	my %x;
	foreach (@b) {
		if ($sam_hap{$_}) {
			$x{$sam_hap{$_}} = 1;
		}
	}
	my @y = keys %x;
	if (@y == 0) {
		print O2 "$_\n";
		next;
	} elsif (@y == 1) {
		$a[23] = $y[0];
		$a[24] = $hap_seq{$y[0]};
		print O2 join("\t", @a), "\n";
		print O1 ">$a[0]_$a[25]\n$hap_seq{$y[0]}\n";
	} else {
		warn $a[0];
	}
}
close I1;
close O1;
close O2;
