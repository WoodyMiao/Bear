#!/usr/bin/perl
use strict;
#use warnings;

open INFO, "<", "Black_bear_DNA_Russia_info.txt";
open GT, "<", "Russia_gt_8loci_noS_correct.indiv";
open O, ">", "Russia_gt_8loci_noS_correct_info.indiv";

my $a0 = <INFO>;
$a0 =~ s/\r//;
chomp $a0;
my @a0 = split /\t/, $a0;
my @title = ($a0[5], $a0[7], $a0[12], $a0[13], $a0[15]);
my %info;
while (<INFO>) {
	s/\r//;
	chomp;
	my @a = split /\t/;
	@{$info{$a[1]}}= ($a[5], $a[7], $a[12], $a[13], $a[15]);
	#warn $a[1];
	#warn @{$info{$a[1]}};
}
close INFO;

my %info1;
foreach (sort keys %info) {
	next if /-[2-4]$/;
	if (/^(Olga[0-9]{3})-1$/) {
		my @a;
		foreach (1..4) {
			my $b = "$1-$_";
			#warn $b;
			if (defined $info{$b}) {
				if (defined $info{$b}[3]) {
					@a = @{$info{$b}};
					#warn @a;
					last;
				}
			}
		}
		if (defined $a[0]) {
			@{$info1{$1}} = @a;
			#warn $1;
			#warn @{$info1{$1}};
		} else {
			@{$info1{$1}} = @{$info{$_}};
			#warn $1;
			#warn @{$info1{$1}};
		}
	} else {
		@{$info1{$_}} = @{$info{$_}};
		#warn $_;
		#warn @{$info1{$_}};
	}
}

$a0 = <GT>;
chomp $a0;
print O "$a0\t\t";
print O join "\t", @title;
print O "\n";

while (<GT>) {
	if (/^(Olga[0-9]{3})/) {
		chomp;
		print O "$_\t";
		print O join "\t", @{$info1{$1}};
		print O "\n";
	} else {
		print O $_;
	}
}
close GT;
close O;








