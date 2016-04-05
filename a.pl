#!/usr/bin/perl
use strict;
use warnings;

while (<>) {
	chomp;
	/^(Russia_[0-9A-Z]+_ML) Genotypes Table.txt$/;
	print "./format.pl $1\\ Genotypes\\ Table.txt >$1_allelegram_input.txt\n";
}
