#!/usr/bin/perl
use strict;
use warnings;

open I1, "<", "CR_CYTB_aligned_revised_2nd_haplotype.txt";
open I2, "<", "Info_ChinaFeces.txt";
open I3, "<", "CR_CYTB_Info_GenBankSeq.txt";
open O, ">", "CR_CYTB_haplotype_geo_info_2nd.txt";

my %res_mou = (
	Tangjiahe	=>	"Minshan",
	Dongyanggou	=>	"Minshan",
	Wanglang	=>	"Minshan",
	Xiaohegou	=>	"Minshan",
	Xuebaoding	=>	"Minshan",
	Yele	=>	"Xiangling",
	Meigu	=>	"Liangshan",
	Changqing	=>	"Qinling",
	Gaoligongshan	=>	"Gaoligongshan",
);

my %hap_sam;
while (<I1>) {
	next unless /^>/;
	chomp;
	my @a = split /\t/;
	my @b = split / /, $a[1];
	$a[0] =~ s/^>//;
	$hap_sam{$a[0]} = \@b;
}
close I1;

my %sam_geo;
<I2>;
while (<I2>) {
	my @a = split /\t/;
	$sam_geo{$a[0]} = $a[1];
}
close I2;

<I3>;
while (<I3>) {
	my @a = split /\t/;
	$sam_geo{$a[0]} = $a[1];
}
close I3;

my %hap_geo;
my %hap_mou;
foreach my $a (keys %hap_sam) {
	my %res;
	my %mou;
	foreach my $b (@{$hap_sam{$a}}) {
		if (exists $sam_geo{$b}) {
			$mou{$res_mou{$sam_geo{$b}}} = 1 if exists $res_mou{$sam_geo{$b}};
			$res{$sam_geo{$b}} = 1;
		}
	}
	foreach my $c (keys %mou) {
		$hap_mou{$a} .= $c if $c;
	}
	foreach my $c (keys %res) {
		$hap_geo{$a} .= "$c" if $c;
	}
}

foreach (sort keys %hap_sam) {
	if (exists $hap_geo{$_}) {
		if (exists $hap_mou{$_}) {
			print O "$_\t$hap_mou{$_}\t$hap_geo{$_}\n";
		} else {
			print O "$_\t$hap_geo{$_}\n";
		}
	} else {
		if ($hap_sam{$_}[0] =~ /^KARB/) {
			print O "$_\tBear_farm\n";
		} elsif ($hap_sam{$_}[0] =~ /^OLGA/) {
			print O "$_\tRussian\n";
		} elsif ($hap_sam{$_}[0] =~ /^UT/) {
			print O "$_\tRussian\n";
		}
	}
}
close O;
