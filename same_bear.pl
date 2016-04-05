#!/usr/bin/perl
use strict;
use warnings;

$_ = <>;
chomp;
s/Sample\t//;
print "$_\t\tSample\n";

my %sample;
while (<>) {
  chomp;
  my @a = split /\t/;
  my $id = shift @a;
  $sample{$id} = join "\t", @a;
}

my %gt;
foreach (keys %sample) {
  push @{$gt{$sample{$_}}}, $_;
}

foreach (sort keys %gt) {
  print $_, "\t";
  print join ",", @{$gt{$_}};
  print "\n";
}
