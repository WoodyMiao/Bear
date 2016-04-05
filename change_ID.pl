#!/usr/bin/perl
use strict;
use warnings;

while (<>) {
	if (/^Olga/) {
		s/^Olga/OLGA0/;
		print $_;
	} elsif (/^UT/) {
		s/^UT/UT000/;
		print $_;
	} else {
		print $_;
	}
}
