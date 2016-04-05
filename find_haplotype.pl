#!/usr/bin/perl
use strict;
use warnings;

my $in = shift;
my $out = shift;
open I, "<", "$in";
open O, ">", "$out";

# Load input file into @gt and %gt.
# my $head = <I>;
my (@gt, %gt);
while (<I>) {
	s/\r//;
	chomp;
	my @a = split /\t/;
	push @gt, [@a];
	my $b = shift @a;
	$gt{$b} = \@a;
}
close I;
warn "Read input complete!\n";

# Compare every two samples, and load compatible pairs into @line.
my $ns = @gt; # number of sample
my @line; # In the array @line of arrays, every array contains two compatible samples.
foreach my $a (0 .. $ns-2) {
	foreach my $b ($a+1 .. $ns-1) {
		push @line, [$gt[$a][0], $gt[$b][0]] if &identical($gt[$a][1], $gt[$b][1]) and &compatible($gt[$a][2], $gt[$b][2]);
	}
}
warn "Compare every two samples complete!\n";

# Push certain individual group arrays into @ss, uncertain group arrays into @sn.
my @ss; # samples sure
my @sn; # samples not sure
foreach (@line) {
	if (!defined ${$_}[2]) {
		${$_}[2] = 1; # Mark considered sample pair.
		push my @a, (${$_}[0], ${$_}[1]);
		my @s = @a;
		while (@a) { # The while loop will recursively find $_'s all intercompatible samples, and push them into @s.
			my @c;
			foreach my $v (@a) {
				my @w;
				foreach (@line) { # The foreach loop will find $_'s all compatible samples, and push them into @w.
					if (!defined ${$_}[2]) {
						if (${$_}[0] eq $v or ${$_}[1] eq $v) {
							${$_}[2] = 1;
							push @w, (${$_}[0], ${$_}[1]);
						}
					}
				}
				push @c, @w;		
			}
			@a = @c;
			push @s, @a;
		}
		my %c; # Array @s contain intercompatible samples. The occurrence number of one sample equals the number of its compatible samples. 
		foreach (@s) {
			++$c{$_};
		}
		my %d;
		++$d{$c{$_}} foreach keys %c;
		push @ss, \@s if keys %d == 1; # If the occurrence numbers of all samples are equal, the samples should be one individual.
		push @sn, \@s if keys %d >= 2; # If the numbers are not equal, the samples are uncertain.
	}
}
warn "Grouping complete!\n";

my @hs; # haplotype sequence.
my $e = 1;
foreach (@ss) {
	my %s;
	foreach (@{$_}) {
		$s{$_} = $gt{$_};
	}
	my @cr;
	my @cb;
	my @v;
	foreach (sort keys %s) {
		push @cr, $s{$_}[0];
		push @cb, $s{$_}[1];
		push @v, [$_, @{$s{$_}}];
	}
	unshift @v, [sprintf("Haplo%03d", $e), &identical(@cr), &compatible(@cb)];
	++$e;
	push @hs, \@v;
}

# print haplotypes;
foreach (@hs) {
	foreach (@{$_}) {
		my $a = join "\t", @{$_};
		print O "$a\n";
	}
	print O "\n";
}
warn "Printing haplotypes complete!\n";

# Print uncertain groups.
foreach (@sn) {
	my %s;
	foreach (@{$_}) {
		$s{$_} = $gt{$_};
	}
	print O "Uncertain $e\n";
	++$e;
	foreach (sort keys %s) {
		print O "$_\t";
		print O join "\t", @{$s{$_}};
		print O "\n";
	}
	print O "\n";
}

# Print haplotypes with only one sample.
foreach (@line) {
	$gt{${$_}[0]} = 0;
	$gt{${$_}[1]} = 0;
}
print O "Haplotypes With Only One Sample\n";
foreach (sort keys %gt) {
	if ($gt{$_}) {
		print O "$_\t";
		print O join "\t", @{$gt{$_}};
		print O "\n";
	}
}
close O;
warn "Done!\n";

sub identical {
	my $con = $_[0];
	my $len = length $con;
	my $n = @_ - 1;
	my $error;
	foreach my $b (1 .. $n) {
		for (my $i = 0; $i < $len; $i++) {
			if (substr($con,$i,1) eq substr($_[$b],$i,1)) {
				next;
			} else {
				$error = 1;
				last;
			}
		}
	}
	if ($error) {
		return 0;
	} else {
		return $con;
	}
}

sub compatible {
	my $con = $_[0];
	my $len = length $con;
	my $n = @_ - 1;
	my $error;
	foreach my $b (1 .. $n) {
		for (my $i = 0; $i < $len; $i++) {
			if (substr($_[$b],$i,1) eq "-") {
				next;
			} else {
				if (substr($con,$i,1) eq "-") {
					substr($con,$i,1) = substr($_[$b],$i,1);
				} else {
					if (substr($con,$i,1) eq substr($_[$b],$i,1)) {
						next;
					} else {
						$error = 1;
						last;
					}
				}
			}
		}
	}
	if ($error) {
		return 0;
	} else {
		return $con;
	}
}
