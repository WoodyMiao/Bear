#!/usr/bin/perl
use strict;
use warnings;

open I1, "<", "../3.feces_China_samples/Indiv_black_bear_gt_input.txt";
open I2, "<", "../Indiv_black_bear_info.txt";
open O, ">", "China_feces_STR_genotype_8loci_final.txt";

my %ind_sam;
while (<I2>) {
	my $a;
	if (/^(Indiv\d{3})/) {
		$a = <I2>;
		my $indiv = $1;
		while ($a =~ /^(KARS\d{4})/) {
			push @{$ind_sam{$indiv}}, $1;
			$a = <I2>;
		}
	}
}

print O "#IndivID\tA107\t\tABB2\t\tABB4\t\tABB5\t\tB7\t\tB8\t\tD103\t\tD2\t\tG10L\t\tG10M\t\tG10P\t\tSampleID\n";

my $nInd;
while (<I1>) {
	++$nInd;
	chomp;
	if (/^(Indiv\d{3})/) {
		print O $_;
		print O "\t", join(",", @{$ind_sam{$1}}), "\n";
	} elsif (/^KARS\d{4}/) {
		my @a = split /\t/;
		my $sam = shift @a;
		unshift @a, sprintf("Indiv%03d", $nInd);
		push @a, $sam;
		print O join("\t", @a), "\n";
	} else {
		warn;
	}
}
close I1;
close I2;
close O;
