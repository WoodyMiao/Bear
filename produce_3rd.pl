#!/usr/bin/perl
use strict;
use warnings;

open I1, "<", "CR_CYTB_aligned_revised_2nd_haplotype.nex";
open I2, "<", "CR_CYTB_haplotype_geo_info_2nd.txt";
open O, ">", "CR_CYTB_aligned_revised_3rd_haplotype.nex";

my %hap_geo;
while (<I2>) {
	chomp;
	my @a = split /\t/;
	if ($a[1] =~ /Korea/) {
		$hap_geo{$a[0]} = "Korea";
	} elsif ($a[1] =~ /Bear/) {
		next;
	} else {
		$hap_geo{$a[0]} = $a[1];
	}
}
close I2;

while (<I1>) {
	print O $_;
	last if /Matrix/;
}

my %hap_seq;
my $ntaxa;
while (<I1>) {
	last if /^;/;
	my @a = split /\t/;
	if (exists $hap_geo{$a[0]}) {
		++$ntaxa;
		$hap_seq{$a[0]} = [$hap_geo{$a[0]}, $a[1]];
	} else {
		next;
	}
}

foreach (sort {$hap_seq{$a}[0] cmp $hap_seq{$b}[0]} keys %hap_seq) {
	print O "${_}_$hap_seq{$_}[0]\t$hap_seq{$_}[1]";
}

print O ";
END;
ntaxa = $ntaxa
";
close O;
