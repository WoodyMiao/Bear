#!/usr/bin/perl
use strict;
use warnings;

open O, ">", "run_find_haplotype.sh";
my $j = 300;
for (my $i = 1; $i <= 5; ++$i) {
	print O "mkdir $i.samples_have_${j}bp_CytB\n";
	print O "./remove_sample.pl $j $i.samples_have_${j}bp_CytB/concatenated_mt_with_${j}bp_CytB.txt\n";
	print O "./find_haplotype.pl $i.samples_have_${j}bp_CytB/concatenated_mt_with_${j}bp_CytB.txt $i.samples_have_${j}bp_CytB/mt_${j}bp_CytB_haplotype.txt\n";
	print O "./count_haplotype_CytB_bp_and_output_haplotype.pl $i.samples_have_${j}bp_CytB/mt_${j}bp_CytB_haplotype\n"; 
	$j += 200;
}
close O;
