#!/usr/bin/perl
use strict;
use warnings;

my $in = shift;
my $out = shift;
my %s = (
S007	=>	"KARB0001",
S024	=>	"KARB0002",
S025	=>	"KARB0003",
S034	=>	"KARB0004",
S036	=>	"KARB0005",
S050	=>	"KARB0006",
S055	=>	"KARB0007",
S057	=>	"KARB0008",
S060	=>	"KARB0009",
S078	=>	"KARB0010",
S079	=>	"KARB0011",
S102	=>	"KARB0012",
S113	=>	"KARB0013",
S117	=>	"KARB0014",
S128	=>	"KARB0015",
S131	=>	"KARB0016",
S137	=>	"KARB0017",
S156	=>	"KARB0018",
S166	=>	"KARB0019",
S169	=>	"KARB0020",
S177	=>	"KARB0021",
S178	=>	"KARB0022",
S181	=>	"KARB0023",
S186	=>	"KARB0024",
S204	=>	"KARB0025",
S213	=>	"KARB0026",
S227	=>	"KARB0027",
S245	=>	"KARB0028",
S161	=>	"KARB0029",
S258	=>	"KARB0030",
S256	=>	"KARB0031",
S249	=>	"KARB0032",
S255	=>	"KARB0033",
S257	=>	"KARB0034",
S126	=>	"KARB0035",
);
open I, "<", $in;
open O, ">", $out;

my %fasta;
while (<I>) {
	s/^>//;
	$/ = ">";
	my $seq = <I>;
	chomp $seq;
	$seq =~ s/\s//g;
	$/ = "\n";
	my $id;
	if (/^(?:Olga)?(\d+)/) {
		$id = sprintf "OLGA%04d", $1;
	} elsif (/^STH(\d+)/) {
		$id = sprintf "STH%05d", $1;
	} elsif (/^UT(\d+)/) {
		$id = sprintf "UT%06d", $1;
	} elsif (/^[Ss](\d+)/) {
		my $a = sprintf "S%03d", $1;
		$id = $s{$a};
	}else {
		warn $_;
	}
	push @{$fasta{$id}}, $seq;
}
close I;

foreach my $a (sort keys %fasta) {
	foreach (@{$fasta{$a}}) {
		print O ">$a\n$_\n";
	}
}
close O;
