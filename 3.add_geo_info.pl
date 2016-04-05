#!/usr/bin/perl
use strict;
use warnings;

open I1, "<", "full_CR_CYTB_sample_aligned_haplotype_revised.txt";
open I2, "<", "Info_ChinaFeces.txt";
open O, ">", "CR_CYTB_18.fasta";

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

my %sam_mou;
<I2>;
while (<I2>) {
	my @a = split /\t/;
	$sam_mou{$a[0]} = $res_mou{$a[1]};
}
close I2;

while (<I1>) {
	chomp;
	my @a = split /\t/;
	my @b = split / /, $a[1] if $a[1];
	my %c;
	foreach (@b) {
		++$c{Russia} if (/OLGA|STH|UT/);
		++$c{$sam_mou{$_}} if $sam_mou{$_};
	}
	print O "$a[0]";
	print O "_$_" foreach sort keys %c;
	print O " $_ $c{$_}" foreach sort keys %c;
	print O "\n";
	my $seq = <I1>;
	print O $seq;
}

close I1;
close O;
