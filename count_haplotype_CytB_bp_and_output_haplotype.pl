#!/usr/bin/perl
use strict;
use warnings;

my $in = shift;
open I, "<", "$in.txt";
open O1, ">", "${in}_CytB_bp.log";
open O2, ">", "$in.fasta";
my %bp;
my $nh = 1; # No. Haplo.
while (<I>) {
	next unless /^Haplo/;
	last if /^Haplotypes/;
	chomp;
	my @a = split /\t/;
	my $n = sprintf("Haplo%03d", $nh);
	my @b;
	while (<I>) {
		last unless /^\w/;
		my @c = split /\t/;
		push @b, $c[0];
	}
	print O2 ">$n\t", join(" ", @b), "\n$a[1]$a[2]\n";
	++$nh;
	$bp{$a[0]} = @{[$a[2] =~ /[ATCG]/g]};
}
while (<I>) {
	chomp;
	my @a = split /\t/;
	my $n = sprintf("Haplo%03d", $nh);
	print O2 ">$n\t$a[0]\n$a[1]$a[2]\n";
	++$nh;
	$bp{$a[0]} = @{[$a[2] =~ /[ATCG]/g]};
}
close I;
close O2;

print O1 "#Haplotype\tCytB bp\n";
my %n;
foreach (sort keys %bp ) {
	print O1 "$_\t$bp{$_}\n";
	++$n{$bp{$_}};
}

print O1 "No. bp\tNo. haplotypes\n";
my $t;
foreach (sort {$b <=> $a} keys %n) {
	print O1 "$_\t$n{$_}\n";
	$t += $n{$_}
}
print O1 "Total\t$t\n";
close O1;
