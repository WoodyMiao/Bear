#!/usr/bin/perl
use strict;
use warnings;

my @extraparams = qw/ extraparams_admix_corre extraparams_admix_indep extraparams_noadm_corre extraparams_noadm_indep /;

open O, ">", "run_structure.sh";

foreach (@extraparams) {
	/(\w{12})$/;
	foreach my $k (2 .. 9) {
		print O "structure -e $_ -K $k -o output$1_K$k >output$1_K$k.log 2>&1 &\n";
	}
}

close O;
