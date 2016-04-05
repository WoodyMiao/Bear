#!/usr/bin/perl
use strict;
use warnings;

open O, ">", "run_mp_bs.sh";

foreach my $n (1..60) {
	open my $o, ">", "mp_bs_rep$n.nex";
	print $o "#NEXUS
begin paup;
set autoclose=yes increase=auto warntree=no warnreset=no;
execute CR_haplotype.nex;
hsearch addseq=random;
bootstrap treefile=mp_bs_rep$n.tre nreps=2;
quit;
end;\n";
	close $o;
	print O "paup mp_bs_rep$n.nex >mp_bs_rep$n.log 2>&1 &\nsleep 1\n";
}

close O;
