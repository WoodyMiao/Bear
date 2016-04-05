#!/usr/bin/perl
use strict;
use warnings;

open I, "<", "CR_CYTB_all_available_haplotype_sample.txt";
open O, ">", "tip_labels.txt";

my %old_new = qw/ OLGA0068 RFEB0124 OLGA0074 RFEB0130 OLGA0086 RFEB0136 OLGA0094 RFEB0144 OLGA0096 RFEB0145 OLGA0106 RFEB0152 OLGA0125 RFEB0159 OLGA0131 RFEB0165 OLGA0152 RFEB0178 OLGA0180 RFEB0205 OLGA0181 RFEB0206 OLGA0186 RFEB0211 OLGA0207 RFEB0224 OLGA0209 RFEB0226 OLGA0236 RFEB0246 OLGA0246 RFEB0256 OLGA0257 RFEB0267 OLGA0264 RFEB0274 OLGA0265 RFEB0275 OLGA0274 RFEB0284 OLGA0279 RFEB0289 OLGA0280 RFEB0290 OLGA0281 RFEB0291 UT000099 RFEB0294 UT000106 RFEB0295 UT000107 RFEB0296 UT000108 RFEB0297 STH5 STH5 STH6 STH6 STH9 STH9 UT01 SEAB0001 UT02 SEAB0002 UT03 SEAB0003 /;

while (<I>) {
	chomp;
	my @a = split /\t/;
	print O "$a[0]\t";
	if ($a[0] =~ /^AB|EU|EF/) {
		my @b = split /_/, $a[0];
		print O "$a[1] haplotype ($b[0]_$b[1])\n";
	} elsif ($a[0] =~ /^NC/) {
		print O "$a[1] (GenBank RefSeq: $a[0])\n";
	} else {
		my @b = split /_/, $a[0];
		if ($a[3] =~ /^KARS/) {
			print O "$b[2] (KARS";
			my @c = split / /, $a[3];
			foreach (@c) {
				$_ =~ s/KARS//;
				$_ += 0;
			}
			print O join(",", sort {$a <=> $b} @c), ", $a[2]) $a[1]";
		} elsif ($a[1] eq "Russia") {
			my @c = split / /, $a[3];
			my @d1;
			my @d2;
			foreach (@c) {
				if (/^OLGA|UT/) {
					if ($old_new{$_}) {
						$_ = $old_new{$_};
						$_ =~ s/RFEB//;
						$_ += 0;
						push @d1, $_;
					} else {
						next;
					}
				} elsif (/^STH/) {
					$_ =~ s/STH//;
					push @d2, $_;
				}
			}
			my $e = @d1+@d2;
			print O "$b[2] (RFEB", join(",", sort {$a <=> $b} @d1), ",STH", join(",", sort {$a <=> $b} @d2), ", n=$e) $a[1]";
		} else {
			print O "$b[2] (SEAB1,2,3, n=3) Thailand";
		}
		print O "\n";
	}
}
close I;
close O;
