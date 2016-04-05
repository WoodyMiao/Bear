#!/usr/bin/perl
use strict;
use warnings;

open I, "<", "../../b.new_set_of_data/22_Russia_106_China_8_loci.txt";
open O, ">", "22_Russia_106_China_8_loci_1_column.txt";

my %geo_ind;
while (<I>) {
	chomp;
	my @b = split /\t/;
	my $ind = shift @b;
	pop @b;
	pop @b;
	my $geo = pop @b;
	$geo_ind{$geo}{$ind} = \@b;
}
close I;

foreach my $b (sort keys %geo_ind) {
	print O "$b\n";
	foreach my $c (sort keys %{$geo_ind{$b}}) {
		my @d = @{$geo_ind{$b}{$c}};
		print O "\t\t$c\t1\t$d[0]\t$d[2]\t$d[4]\t$d[6]\t$d[8]\t$d[10]\t$d[12]\t$d[14]\t$d[16]\t$d[18]\t$d[20]\n";
		print O "\t\t\t\t$d[1]\t$d[3]\t$d[5]\t$d[7]\t$d[9]\t$d[11]\t$d[13]\t$d[15]\t$d[17]\t$d[19]\t$d[21]\n";
	}
}
close O;
