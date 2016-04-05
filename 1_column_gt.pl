#!/usr/bin/perl
use strict;
use warnings;

open I1, "<", "../../i.Structure/4.feces_China_genotype_to_Karl/China_feces_STR_genotype_8loci_final.txt";
open I2, "<", "../../b.STR_mtDNA_final/Info_ChinaFeces.txt";
open O, ">", "China_feces_1_column_gt.txt";

<I2>;
my %sam_geo;
while (<I2>) {
	my @b = split /\t/;
	$sam_geo{$b[0]} = $b[1];
}
close I2;

my $a = <I1>;
chomp $a;
substr $a, 0, 9, "";
my @loci = split /\t\t/, $a;

my %geo_ind;
while (<I1>) {
	chomp;
	my @b = split /\t/;
	my $ind = shift @b;
	my $c = pop @b;
	my @sam = split /,/, $c;
	my $geo;
	foreach (@sam) {
		if (!$geo) {
			$geo = $sam_geo{$_};
			warn $_, if $sam_geo{$_} eq "0";
		} else {
			warn if $geo ne $sam_geo{$_};
		}
	}
	$geo_ind{$geo}{$ind}[0] = $c;
	$geo_ind{$geo}{$ind}[1] = \@b;
}
close I1;

print O "#IndivID\t\t", join("\t", @loci), "\n";
foreach my $b (sort keys %geo_ind) {
	print O "$b\n";
	foreach my $c (sort keys %{$geo_ind{$b}}) {
		my @d = @{$geo_ind{$b}{$c}[1]};
		print O "$c\t1\t$d[0]\t$d[2]\t$d[4]\t$d[6]\t$d[8]\t$d[10]\t$d[12]\t$d[14]\t$d[16]\t$d[18]\t$d[20]\t$geo_ind{$b}{$c}[0]\n";
		print O "\t\t$d[1]\t$d[3]\t$d[5]\t$d[7]\t$d[9]\t$d[11]\t$d[13]\t$d[15]\t$d[17]\t$d[19]\t$d[21]\n";
	}
}
close O;
