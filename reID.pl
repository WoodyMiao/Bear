#!/usr/bin/perl
use strict;
use warnings;

open I1, "<", "sample_info.txt";
open I2, "<", "individual_genotype_oldID.txt";
open O1, ">", "individual_genotype_PKUid.txt";
open O2, ">", "selected_individual_genotype_PKUid.txt";

my %sample = qw/ UT000099 RFEB0294 UT000106 RFEB0295 UT000107 RFEB0296 UT000108 RFEB0297 /; 
while (<I1>) {
	chomp;
	my @a = split /\t/;
	if ($a[4] =~ /^\d+/) {
		my $b = sprintf("OLGA%04d", $a[4]);
		$sample{$b} = $a[0];
	} else {
		next;
	}
}
close I1;

my $title = <I2>;
<I2>;
my $n = 0;
my @id_gt;
my @id_sa;
my %sa_gt;
while (<I2>) {
	if (/^Indiv\d{3}/) {
		++$n;
		my @a = split /\t/, $_;
		shift @a;
		$id_gt[$n] = join("\t", @a);
		my $s = <I2>;
		while ($s =~ m/^KA|OL|UT/) {
			my @b = split /\t/, $s;
			$b[0] = $sample{$b[0]};
			$sa_gt{$b[0]} = join("\t", @b);
			push @{$id_sa[$n]}, $b[0];
			$s = <I2>;
		}
	} elsif (/^Individuals/) {
		while (<I2>) {
			++$n;
			my @b = split /\t/;
			$b[0] = $sample{$b[0]};
			push @{$id_sa[$n]}, $b[0];
			$sa_gt{$b[0]} = join("\t", @b);
			shift @b;
			$id_gt[$n] = join("\t", @b);
		}
	} else {
		warn;
	}
}
close I2;

print O1 $title;
my @mt; # individual with mt sequence;
foreach (1 .. $n) {
	my $a = sprintf("Indiv%03d", $_);
	print O1 "\n$a\t$id_gt[$_]";
	foreach (@{$id_sa[$_]}) {
		print O1 $sa_gt{$_};
	}
	chomp $id_gt[$_];
	my @b = split /\t/, $id_gt[$_];
	if ($b[-1] and $b[-2]) {
		unless ($b[-1] =~ /-/) {
			push @mt, $_;
		}
	}
}
close O1;

chomp $title;
print O2 $title, "\tSample\n";
foreach (0 .. 9) {
	my $nmt = @mt - 3;
	my $r = int(rand($nmt));
	my $i = $mt[$r];
	splice @mt, $r, 1;
	my $a = sprintf("Indiv%03d", $i);
	print O2 "$a\t$id_gt[$i]\t", join(",", @{$id_sa[$i]}), "\n";
}
foreach (-3 .. -1) {
	my $i = $mt[$_];
	my $a = sprintf("Indiv%03d", $i);
	print O2 "$a\t$id_gt[$i]\t", join(",", @{$id_sa[$i]}), "\n";
}
close O2;











