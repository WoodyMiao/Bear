#!/usr/bin/perl
use strict;
use warnings;

open I, "<", "black_bear_mt_haplotype.txt";
my (@fc, @bc, @r);
while (<I>) {
	last if /^>A/;
	my @a = split /\t/;
	my $s = <I>;
	my @b = split / /, $a[1];
	foreach (@b) {
		if (/^KARS/) {
			++$fc[1];
		} elsif (/^KARB/) {
			++$bc[1];
		} else {
			++$r[1];
		}
	}
	if (@{[$s =~ /N|\?/g]} == 0) {
	foreach (@b) {
		if (/^KARS/) {
			++$fc[3];
		} elsif (/^KARB/) {
			++$bc[3];
		} else {
			++$r[3];
		}
	}
	}
	if ($a[1] =~ /^KARS/) {
		++$fc[0];
		if (@{[$s =~ /N|\?/g]} == 0) {
			++$fc[2];
		}
	} elsif ($a[1] =~ /^KARB/) {
		++$bc[0];
		if (@{[$s =~ /N|\?/g]} == 0) {
			++$bc[2];
		}
	} else {
		++$r[0];
		if (@{[$s =~ /N|\?/g]} == 0) {
			++$r[2];
		}
	}
}
close I;

open O, ">", "count.log";
print O "\thaplotype	sample_covered	haplotype_full_length	sample_covered
feces_China	$fc[0]	$fc[1]	$fc[2]	$fc[3]
blood_China	$bc[0]	$bc[1]	$bc[2]	$bc[3]
Russia	$r[0]	$r[1]	$r[2]	$r[3]\n";
close O;

