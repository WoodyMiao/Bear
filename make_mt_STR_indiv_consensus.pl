#!/usr/bin/perl
use strict;
use warnings;

open I, "<", "Indiv_black_bear.txt";
open my $i1, "<", "CR_blood_China_Russia_consensus.txt";
open my $i2, "<", "CR_feces_China_consensus_end-filled.txt";
open my $i3, "<", "CytB_blood_China_Russia_consensus.txt";
open my $i4, "<", "CytB_feces_China_consensus.txt";
open O1, ">", "mt_STR_indiv_consensus.txt";
open O2, ">", "mt_STR_indiv_consensus.error1.txt";
open O3, ">", "mt_STR_indiv_consensus.error2.txt";

my %cr_bl = %{&readfasta($i1)};
my %cr_fe = %{&readfasta($i2)};
my %cb_bl = %{&readfasta($i3)};
my %cb_fe = %{&readfasta($i4)};
my %cr = (%cr_bl, %cr_fe);
my %cb = (%cb_bl, %cb_fe);

my $title = <I>;
chomp $title;
$title .= "\t\tCR\tCytB";
my (%id_gt, %id_sam, %sam_gt);
while (<I>) {
	chomp;
	if (/^Indiv/) {
		my @a = split /\t/, $_;
		$id_gt{$a[0]} = $_;
		my $s = <I>;
		while ($s =~ m/^KA|OL|UT/) {
			chomp $s;
			my @b = split /\t/, $s;
			$sam_gt{$b[0]} = $s;
			push @{$id_sam{$a[0]}}, $b[0];
			$s = <I>;
		}
	} else {
		warn;
	}
}
close I;

foreach my $a (sort keys %id_sam) {
	my (@cr_seq, @cb_seq);
	foreach my $b (@{$id_sam{$a}}) {
		if (defined $cr{$b}) {
			$sam_gt{$b} .= "\t$cr{$b}";
			push @cr_seq, $cr{$b};
		} else {
			$sam_gt{$b} .= "\t0";
		}
		if (defined $cb{$b}) {
			$sam_gt{$b} .= "\t$cb{$b}";
			push @cb_seq, $cb{$b};
		} else {
			$sam_gt{$b} .= "\t0";
		}
	}
	next if $a =~ m/^Individuals/;
	if (@cr_seq == 0) {
		$id_gt{$a} .= "\t0";
	} elsif (@cr_seq == 1) {
		$id_gt{$a} .= "\t$cr_seq[0]";
	} else {
		my $cr = &identical(@cr_seq);
		$id_gt{$a} .= "\t${$cr}[0]";
		print O3 "$a CR conflict!\t${$cr}[1]\n" if ${$cr}[1];
	}	
	if (@cb_seq == 0) {
		$id_gt{$a} .= "\t0";
	} elsif (@cr_seq == 1) {
		$id_gt{$a} .= "\t$cb_seq[0]";
	} else {
		my $cb = &consensus(@cb_seq);
		$id_gt{$a} .= "\t${$cb}[0]";
		print O3 "$a CytB conflict!\t${$cb}[1]\n" if ${$cb}[1];
	}
}
close O3;

print O2 "#Redundant CR.\n";
foreach (sort keys %cr) {
	print O2 "$_\t$cr{$_}\n" unless defined $sam_gt{$_};
}
print O2 "\n#Redundant CytB.\n";
foreach (sort keys %cb) {
	print O2 "$_\t$cb{$_}\n" unless defined $sam_gt{$_};
}
close O2;

print O1 "$title\n";
foreach (sort keys %id_gt) {
	print O1 "\n$id_gt{$_}\n";
	foreach (@{$id_sam{$_}}) {
		print O1 "$sam_gt{$_}\n";
	}
}
close O1;

sub readfasta {
	my $in = $_[0];
	my %fa;
	while (<$in>) {
		chomp;
		s/>//;
		$/ = ">";
		my $seq = <$in>;
		chomp $seq;
		$seq =~ s/\s//g;
		$/ = "\n";
		$fa{$_} = $seq;
	}
	return \%fa;
}


sub identical {
	my $con = $_[0];
	my $len = length $con;
	my $n = @_ - 1;
	my $error = "coordinate";
	foreach my $b (1 .. $n) {
		for (my $i = 0; $i < $len; $i++) {
			if (substr($con,$i,1) eq substr($_[$b],$i,1)) {
				next;
			} else {
				my $i1 = $i + 1;
				$error .= "\t$i1";
			}
		}
	}
	if ($error ne "coordinate") {
		return [0, $error];
	} else {
		return [$con, 0];
	}
}

sub consensus {
	my $con = $_[0];
	my $len = length $con;
	my $n = @_ - 1;
	my $error = "coordinate";
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
						my $i1 = $i + 1;
						$error .=  "\t$i1";
					}
				}
			}
		}
	}
	if ($error ne "coordinate") {
		return [0, $error];
	} else {
		return [$con, 0];
	}
}
