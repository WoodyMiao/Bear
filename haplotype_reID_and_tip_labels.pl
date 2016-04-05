#!/usr/bin/perl
use strict;
use warnings;

open I, "<", "CR_all_available_haplotype_sample.txt";
open O, ">", "haplotype_reID_and_tip_labels.txt";

my %re_sam = qw/ OLGA0068 RFEB0124 OLGA0074 RFEB0130 OLGA0086 RFEB0136 OLGA0094 RFEB0144 OLGA0096 RFEB0145 OLGA0106 RFEB0152 OLGA0125 RFEB0159 OLGA0131 RFEB0165 OLGA0152 RFEB0178 OLGA0180 RFEB0205 OLGA0181 RFEB0206 OLGA0186 RFEB0211 OLGA0207 RFEB0224 OLGA0209 RFEB0226 OLGA0236 RFEB0246 OLGA0246 RFEB0256 OLGA0257 RFEB0267 OLGA0264 RFEB0274 OLGA0265 RFEB0275 OLGA0274 RFEB0284 OLGA0279 RFEB0289 OLGA0280 RFEB0290 OLGA0281 RFEB0291 UT000099 RFEB0294 UT000106 RFEB0295 UT000107 RFEB0296 UT000108 RFEB0297 STH5 STH5 STH6 STH6 STH9 STH9 UT01 SEAB0001 UT02 SEAB0002 UT03 SEAB0003 /;
my %re_hap = qw/ CR_Uth58 AddCR01 CR_Uth46 AddCR02 CR_Uth51 AddCR03 CR_Uth52 AddCR04 CR_Uth29 AddCR05 CR_Uth47 Uth01CR CR_Uth25 Uth02CR CR_Uth48 Uth03CR CR_Uth49 Uth06CR CR_Uth50 Uth07CR CR_Uth53 Uth08CR CR_Uth54 Uth09CR CR_Uth55 Uth13CR CR_Uth56 Uth14CR CR_Uth57 Uth20CR CR_Uth26 Uth21CR CR_Uth30 Uth23CR CR_Uth31 Uth26CR CR_Uth36 Uth28CR /;

while (<I>) {
	chomp;
	my @a = split /\t/;
	print O "$a[0]\t";
	my @b = split / /, $a[2];
	if ($re_hap{$a[0]}) {
		print O "$re_hap{$a[0]} (";
		my @cKARS;
		my @cRFEB;
		my @cSTH;
		my @cSEAB;
		my @cNCBI;
		foreach (@b) {
			if (/^KARS/) {
				s/KARS//;
				$_ += 0;
				push @cKARS, $_;
			} elsif (/^OLGA|UT00/) {
				if ($re_sam{$_}) {
					$_ = $re_sam{$_};
					s/RFEB//;
					$_ += 0;
					push @cRFEB, $_;
				} else {
					next;
				}
			} elsif (/^STH/) {
				s/STH//;
				$_ += 0;
				push @cSTH, $_;
			} elsif (/UT01|UT02|UT03/) {
				$_ = $re_sam{$_};
				s/SEAB//;
				$_ += 0;
				push @cSEAB, $_;
			} else {
				push @cNCBI, $_;
			}
		}
		my $nKARS = @cKARS;
		my $nRFEB = @cRFEB;
		my $nSTH = @cSTH;
		my $nSEAB = @cSEAB;
		my $nNCBI = @cNCBI;
		my $n = $nKARS + $nRFEB + $nSTH + $nSEAB;
		if ($nKARS) {
			print O "KARS", join(",", sort {$a <=> $b} @cKARS), ",";
		}
		if ($nRFEB) {
			print O "RFEB", join(",", sort {$a <=> $b} @cRFEB), ",";
		}
		if ($nSTH) {
			print O "STH", join(",", sort {$a <=> $b} @cSTH), ",";
		}
		if ($nSEAB) {
			print O "SEAB", join(",", sort {$a <=> $b} @cSEAB), ",";
		}
		if ($nNCBI) {
			print O " n=$n, ", join(",", sort @cNCBI), ",", " a=$nNCBI)";
		} else {
			print O " n=$n)";
		}
		print O " $a[1]\n";
	} else {
		my @c = split /_/, $a[1];
		warn if @c > 2;
		if ($b[0] =~ /AB|AF|EU|HM/) {
			print O "$c[0] haplotype (", join(",", @b), ", $c[1])";
		} elsif (/NC_008753/) {
			print O "U.t.mupinensis (GenBank RefSeq: NC_008753)";
		} elsif (/NC_009331/) {
			print O "U.t.formosanus (GenBank RefSeq: NC_009331)";
		} elsif (/NC_011117/) {
			print O "U.t.ussuricus (GenBank RefSeq: NC_011117)";
		} elsif (/NC_011118/) {
			print O "U.t.thibetanus (GenBank RefSeq: NC_011118)";
		} else {
			warn $_;
		}
		print O "\n";
	}
}
close I;
close O;
