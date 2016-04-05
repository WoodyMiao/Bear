#!/usr/bin/perl
use strict;
use warnings;

=begin comment
IndivID: An application for identification of individuals with genotypes from multiple microsatellite loci

As microsatellites often present high levels of polymorphisms within species, they are often used as molecular markers for intra-specific study. In most genetic-based studies of wildlife, non-invasive sampling of genetic materials, such as hair, feces, feathers, and so on, is extensively used to get animal DNA in the research field of population genetics, molecular ecology, conservation biology, and etc. Because researchers don't handle animals directly, one individual is always sampled repeatedly. So identification of individuals is necessary for performing subsequent analysis. Several loci of microsatellite are often informative enough to identify individuals and get population genetic profile. IndivID is a program designed for identification of individuals using samples with multiple microsatellite loci. The program is written in Perl.

1. Criterion
If genotyping of a locus is repeated three times, false allele hardly occurs, but allele dropout can’t be avoided. So we define one locus of two samples as “Compatible Locus (CL)” if there is no false allele between them. For example, if the diploid genotypes of two samples of a locus are “a/a, a/b” or “a/a, b/b”, the locus of the two samples are CL; if one or two of the two samples are missing data, the locus are also CL; but if more than two alleles appear in one locus of two samples, like “a/a, b/c” or “a/b, b/c” or “a/b, c/d”, the locus are not CL. Then we define two samples as “Compatible Samples (CS)” if all loci of the two samples are CL. After defining every two samples as CS or not CS, we infer that a group of samples belong to one individual, if every two samples in the group are CS and every sample in the group with any sample out of the group are not CS; we define a group of samples as uncertain groups, if not every two samples in the group are CS and every sample in the group with any sample out of the group are not CS. Besides the inferred individuals and the defined uncertain groups, we infer that each of the remained samples is one individual.

2. Input
The program can only deal with diploid genotype now. The input data for each sample must be stored in one row, where each locus is in two consecutive columns. And the columns must be tab-delimited. There must be one pre-genotype column which records sample ID and one pre-genotype row which records locus ID. The loci IDs are delimited by double tabs.

3. Output
The program outputs one file which contains three part. The first part is inferred individuals. For each individual, the first row is inferred genotype, and the following rows are genotypes of samples belong to the individual. The second part is uncertain groups. Samples belong to each group are listed below the group ID. The third part contains individuals with only one sample.

4. Run the program
The program is written in Perl, so the operating system must have Perl installed. Copy the program code file and the input data file to an appropriate folder. Then open a command-line interface. Run the program by typing “perl <code file name> <input file name> <output file name>” and press enter.
=end comment
=cut

die("
Program: IndivID
Version: 1.0
Release: Mar. 6, 2013\n
Auther: Woody
Consultant: Galaxy\n
Usage: $0 <input> <output>\n
The input file should look like:\n
#ID	Locus1		Locus2		Locus3		...
Sample1	160	162	166	166	0	0	...
Sample2	0	0	174	176	178	178	...
Sample3	180	182	186	186	188	188	...
...	...	...	...	...	...	...	...
\nMissing data must be \"0\".
\n") if (@ARGV<2);

my $in = shift;
my $out = shift;
open I, "<", "$in";
open O, ">", "$out";

# Load input file into @gt and %gt.
my $head = <I>;
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

# Compare every two samples, and load compatible pairs into @line.
my $ns = @gt; # number of sample
my $nl = (@{$gt[0]}-1)/2; # number of loci
my @line; # In the array @line of arrays, every array contains two compatible samples.
foreach my $a (0 .. $ns-2) {
	foreach my $b ($a+1 .. $ns-1) {
		my $d;
		foreach my $c (1 .. $nl) {
			my %na; # number of allele
			$na{$gt[$a][2*$c-1]} = 1;
			$na{$gt[$a][2*$c]} = 1;
			$na{$gt[$b][2*$c-1]} = 1;
			$na{$gt[$b][2*$c]} = 1;
			if (!defined $na{0} and (keys %na) > 2) { # If there are no "0" alleles and number of allele > 2, it is not a compatible locus.
				$d = 1;
				last;
			}
		}
		push @line, [$gt[$a][0], $gt[$b][0]] unless defined $d;
	}
}

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

# Merge samples in @ss into indivuals, and push both indivuals and samples into array @ig.
my @ig; # individual genotype
my $e = 1;
foreach (@ss) {
	my %s;
	foreach (@{$_}) {
		$s{$_} = $gt{$_};
	}
	my @u; # individual genotype
	foreach my $c (0 .. $nl-1) {
		my %t;
		foreach my $b (keys %s) {
			$t{$s{$b}[2*$c]} = 1;
			$t{$s{$b}[2*$c+1]} = 1;
		}
		my @d;# locus genotype
		if (keys %t == 3) { # If there are 3 alleles, push two nonzero alleles into @d.
			foreach (sort {$a <=> $b} keys %t) {
				push @d, $_ if $_ != 0;
			}
		} elsif (keys %t == 2) { # If there are two alleles, ...
			if (defined $t{0}) { # If one of the two is zero, push the nonzero one twice into @d.
				foreach (sort {$a <=> $b} keys %t) {
					push @d, ($_, $_) if $_ != 0;
				}
			} else { # If there is no zero allele, push the two alleles into @d.
				push @d, $_ foreach sort {$a <=> $b} keys %t;
			}
		} elsif (keys %t == 1) { # If there is only one allele, push it twice into @d.
			push @d, (keys %t, keys %t);
		} else {
			warn keys %t;
		}
		push @u, @d;
	}
	unshift @u, sprintf("Indiv%03d", $e);
	++$e;
	my @v;
	push @v, \@u;
	foreach (sort keys %s) {
		my @f;
		push @f, $_;
		push @f, @{$s{$_}};
		push @v, \@f;
	}
	push @ig, \@v;
}

# Print individual groups.
print O "$head\n";
foreach (@ig) {
	foreach (@{$_}) {
		my $a = join "\t", @{$_};
		print O "$a\n";
	}
	print O "\n";
}

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

# Print individuals with only one sample.
foreach (@line) {
	$gt{${$_}[0]} = 0;
	$gt{${$_}[1]} = 0;
}
print O "Individuals With Only One Sample\n";
foreach (sort keys %gt) {
	if ($gt{$_}) {
		print O "$_\t";
		print O join "\t", @{$gt{$_}};
		print O "\n";
	}
}
close O;
