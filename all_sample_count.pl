#!/usr/bin/perl
use strict;
use warnings;

open I1, "<", "Info_ChinaFeces.txt";
open I2, "<", "CR_CYTB_aligned_revised_2nd_haplotype.txt";
open O, ">", "all_sample_count.txt";

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

my %res_geo1 = (
	Tangjiahe	=>	"Sichuan",
	Dongyanggou	=>	"Sichuan",
	Wanglang	=>	"Sichuan",
	Xiaohegou	=>	"Sichuan",
	Xuebaoding	=>	"Sichuan",
	Yele	=>	"Sichuan",
	Meigu	=>	"Sichuan",
	Changqing	=>	"Qinling",
	Gaoligongshan	=>	"Gaoligongshan",
);

my %res_geo2 = (
	Tangjiahe	=>	"Qinling_Sichuan",
	Dongyanggou	=>	"Qinling_Sichuan",
	Wanglang	=>	"Qinling_Sichuan",
	Xiaohegou	=>	"Qinling_Sichuan",
	Xuebaoding	=>	"Qinling_Sichuan",
	Yele	=>	"Qinling_Sichuan",
	Meigu	=>	"Qinling_Sichuan",
	Changqing	=>	"Qinling_Sichuan",
	Gaoligongshan	=>	"Gaoligongshan",
);

my %geo_sam;
my %geo1_sam;
my %geo2_sam;
<I1>;
while (<I1>) {
	my @a = split /\t/;
	next if $a[1] eq "0";
	warn $_ unless exists $res_mou{$a[1]};
	push @{$geo1_sam{$res_geo1{$a[1]}}}, $a[0];
	push @{$geo2_sam{$res_geo2{$a[1]}}}, $a[0];
	push @{$geo_sam{$res_mou{$a[1]}}}, $a[0];
}
close I1;

my %sam_hap;
while (<I2>) {
	next unless s/^>//;
	chomp;
	my @a = split /\t/;
	my @b = split / /, $a[1];
	foreach (@b) {
		if (/OLGA|UT|STH/) {
			push @{$geo_sam{Russia}}, $_;
			push @{$geo1_sam{Russia}}, $_;
			push @{$geo2_sam{Russia}}, $_;
		}
		$sam_hap{$_} = $a[0];
	}
}
close I2;

foreach my $a (sort keys %geo_sam) {
	my $tot_num;
	my %hap_num;
	foreach my $b (@{$geo_sam{$a}}) {
		next unless exists $sam_hap{$b};
		++$tot_num;
		++$hap_num{$sam_hap{$b}};
	}
	warn $a unless $tot_num;
	print O "$a\n\tSampleSize\t$tot_num\n";
	foreach (sort keys %hap_num) {
		print O "\t\t$_\t$hap_num{$_}\n";
	}
}
print O "____________________\n\n";
foreach my $a (sort keys %geo1_sam) {
	my $tot_num;
	my %hap_num;
	foreach my $b (@{$geo1_sam{$a}}) {
		next unless exists $sam_hap{$b};
		++$tot_num;
		++$hap_num{$sam_hap{$b}};
	}
	warn $a unless $tot_num;
	print O "$a\n\tSampleSize\t$tot_num\n";
	foreach (sort keys %hap_num) {
		print O "\t\t$_\t$hap_num{$_}\n";
	}
}
print O "____________________\n\n";
foreach my $a (sort keys %geo2_sam) {
	my $tot_num;
	my %hap_num;
	foreach my $b (@{$geo2_sam{$a}}) {
		next unless exists $sam_hap{$b};
		++$tot_num;
		++$hap_num{$sam_hap{$b}};
	}
	warn $a unless $tot_num;
	print O "$a\n\tSampleSize\t$tot_num\n";
	foreach (sort keys %hap_num) {
		print O "\t\t$_\t$hap_num{$_}\n";
	}
}
close O;
