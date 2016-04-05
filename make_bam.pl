#!/usr/bin/perl
use strict;
use warnings;

my $in = shift;
my $out = shift;

open I, "<", $in;
open O, "|-", "samtools view -bS - >$out";

while (<I>) {
	next if /^\@HD|\@RG/;
	if (/^\@/) {
		s/16824/16924/g;
		print O $_;
		next;
	}
	my @a = split /\t/;
	$a[8] = 0;
	pop @a;
	$a[0] =~ /^(HWI.+?) .+$/;
	shift @a;
	if ($a[0] == 83 or $a[0] == 99 or $a[0] == 147 or $a[0] == 163) {
		print O "$1\t", join("\t", @a), "\n";
	} else {
		warn $_;
	}
	
}

close I;
close O;
