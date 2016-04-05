#!/usr/bin/perl
use strict;
use warnings;

open I, "-|", "ls -1 output_*_f";
open O, ">", "run_histogram.sh";

while (<I>) {
	print O "../Structure_histogram.pl $_";
}
close I;
close O;
