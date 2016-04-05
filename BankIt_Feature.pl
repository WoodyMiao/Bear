#!/usr/bin/perl
use strict;
use warnings;

my $in = shift;
open I, "<", "$in.fasta";
open O, ">", "$in.tbl";

while (<I>) {
	chomp;
	s/>//;
	my @a = split / /;
	my @b = split /-/, $a[0];
	my $seq = <I>;
	chomp $seq;
	my $len = length $seq;
	if ($b[0] eq "CR") {
		print O ">Feature $a[0]\n";
		print O "<1\t>$len\tD-loop\n\t\t\tnote\tcontrol region\n\t\t\tallele\t$b[1]\n";
	} elsif ($b[0] eq "CYTB") {
		print O ">Feature $a[0]
1	1140	gene
			gene	CYTB
			allele	$b[1]
1	1140	CDS
			gene	CYTB
			codon_start	1
			transl_table	2
			product	cytochrome b
";
	} else {
		print O ">Feature $a[0]\n<1\t>$len\tgene\n\t\t\tgene\t$b[0]\n\t\t\tallele\t$b[1]\n";
		warn "Bad sequence name!";
	}
}
close I;
close O;
my $cmd = "tbl2asn -t Uth.tpm -i $in.fasta -a s2 -V vb";
print "Running:[$cmd]\n";
system($cmd);
#system("ls -l $in.*")
