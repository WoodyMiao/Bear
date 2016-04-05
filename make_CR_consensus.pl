#!/usr/bin/perl
use strict;
use warnings;

my $in = shift;
my $out = shift;
open I, "<", $in;
open O, ">", "$out.txt";
open O1, ">", "$out.error.txt";

my %fa;
while (<I>) {
	chomp;
	s/>//;
	$/ = ">";
	my $seq = <I>;
	chomp $seq;
	$seq =~ s/\s//g;
	$/ = "\n";
	push @{$fa{$_}}, $seq;
}
close I;

my $len;
my %con_fa;
print O1 "#Sequences have only one strand.\n";
foreach my $a (sort keys %fa) {
	my $con = $fa{$a}[0];
	$len = length $con unless defined $len;
	my $n = @{$fa{$a}} - 1;
	if ($n == 0) {
		print O1 ">$a\n$con\n";
	} else {
		foreach my $b (1 .. $n) {
			for (my $i = 0; $i < $len; $i++) {
				if (substr($fa{$a}[$b],$i,1) eq "-") {
					next;
				} else {
					if (substr($con,$i,1) eq "-") {
						substr($con,$i,1) = substr($fa{$a}[$b],$i,1);
					} else {
						if (substr($con,$i,1) eq substr($fa{$a}[$b],$i,1)) {
							next;
						} else {
							print O1 "$a error!\n";
						}
					}
				}
			}
		}
		$con_fa{$a} = $con;
	}
}

print O1 "\n#Sequences whose covergage is less than 50%.\n";
foreach (sort keys %con_fa) {
	if (@{[$con_fa{$_} =~ m/A|T|C|G/g]} < 0.5*$len) {
		print O1 ">$_\n$con_fa{$_}\n";
	} else {
		print O ">$_\n$con_fa{$_}\n";
	}
}
close O;
close O1


