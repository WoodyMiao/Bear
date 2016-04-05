#!/usr/bin/perl
use strict;
use warnings;

open I1, "<", "../d.HaploID/aligned_CR_haplotype.txt";
open I2, "<", "Info_ChinaFeces.txt";
open I3, "<", "GenbankAccession.txt";
open O, ">", "CR_all_available_geoInfo.fasta";

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

<I3>;
while (<I3>) {
	chomp;
	my @a = split /\t/;
	$sam_mou{$a[3]} = $a[1];
}
close I3;

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
	print O "_${_}_n=$c{$_}" foreach sort keys %c;
#	print O " $_ $c{$_}" foreach sort keys %c;
	print O "\n";
	my $seq = <I1>;
	print O $seq;
}

close I1;
close O;
