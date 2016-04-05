#!/usr/bin/perl
use strict;
use warnings;

open SL, "<", "sample.lst";
open LL, "<", "locus.lst";
open AO, "-|", "cat ../c.Russia_allelegram/*output*";

#读取样品列表
my @sample;
while (<SL>) {
	s/\r//;
	chomp;
	s/-1//;
	next if /-[2-9]/;
	push @sample, $_;
}
close SL;

#读取位点列表
my @locus;
while (<LL>) {
  chomp;
  push @locus, $_;
}
close LL;

#把所有样品所有位点都写成"0"
my %gt;
foreach my $a (@sample) {
  foreach my $b (@locus) {
    foreach my $c (1..3) {
      foreach my $d (0..1) {
        $gt{$a}{$b}[$c][$d] = 0;
      }
    }
  }
}

#读取基因型并对%gt重新赋值
while (<AO>) {
  next if /^Sample Name/;
  chomp;
  my @a = split /\t/;
  $a[0] =~ m/^([^_]+)_([^_]+)$/;
  my $m1 = $1;
  my $m2 = $2;
  $m1 =~ s/-\d$//;
  if ($m1 =~ m/^Olga(\d{1,3})$/) {
    $m1 = sprintf "Olga%03s", $1;
  } elsif ($m1 =~ m/^(\d{1,3})$/) {
    if ($1 < 300 ) {
      $m1 = sprintf "Olga%03s", $1;
    } else {
      warn $a[0];
      next;
    }
  } elsif ($m1 =~ m/^U(\d{1,3})$/) {
    $m1 = sprintf "UT%03s", $1;
  } elsif ($m1 =~ m/^S\d{3}q?$/) {
  } else {
    warn $a[0];
    next;
  }
  if (!$gt{$m1}{$m2}[1][0]) {
    $gt{$m1}{$m2}[1][0] = $a[5];
    $gt{$m1}{$m2}[1][1] = $a[6];
  } elsif (!$gt{$m1}{$m2}[2][0]) {
    $gt{$m1}{$m2}[2][0] = $a[5];
    $gt{$m1}{$m2}[2][1] = $a[6];
  } else {
    $gt{$m1}{$m2}[3][0] = $a[5];
    $gt{$m1}{$m2}[3][1] = $a[6];
  }
}
close AO;

#检查基因型是否有错误并决定最终基因型
foreach my $a (@sample) {
  foreach my $b (@locus) {
    my @gt;
    foreach my $c (1..3) {
      foreach my $d (0..1) {
        push @gt, $gt{$a}{$b}[$c][$d];
      }
    }
    my %gttime;
    ++$gttime{$_} foreach (@gt);
    if (defined $gttime{0}) {  #如果有"0"
      if ($gttime{0} == 6) {  #如果6个"0"，就是没有结果
        $gt{$a}{$b}[0][0] = 0;
        $gt{$a}{$b}[0][1] = 0;
      } else {
        @gt = sort keys %gttime;
        @gt = grep {$_ != 0 } @gt;
        if (@gt == 1) {
          $gt{$a}{$b}[0][0] = $gt[0];
          $gt{$a}{$b}[0][1] = $gt[0];
        } elsif (@gt == 2) {
          $gt{$a}{$b}[0][0] = $gt[0];
          $gt{$a}{$b}[0][1] = $gt[1];
        } else {
          warn "$a\t$b";
          $gt{$a}{$b}[0][0] = 0;
          $gt{$a}{$b}[0][1] = 0;
        }
      }
    } else {  #否则就是没有"0"，三次都有结果
      if (keys %gttime == 1) {  #如果只有一个key，就是纯和子
	$gt{$a}{$b}[0][0] = $gt[0];
	$gt{$a}{$b}[0][1] = $gt[0];
      } elsif (keys %gttime == 2) {  #如果有两个key，就考虑是否是真杂和子
	if ($gt[0] == $gt[1] and $gt[2] == $gt[3] and $gt[4] == $gt[5]) {  #如果三次结果都是纯和，就是错了
	  warn "$a\t$b";
	  $gt{$a}{$b}[0][0] = 0;
	  $gt{$a}{$b}[0][1] = 0;
	} else {  #否则至少有一次是杂和子
	  my @gttime;
	  push @gttime, $gttime{$_} foreach (keys %gttime);
	  if ($gttime[0] >= 2 and $gttime[1] >= 2) {  #如果两种基因型都大于两次，就是真杂和子
	    @{$gt{$a}{$b}[0]} = sort keys %gttime;
	  } else {  #否则就是有两次相同的纯和结果，就是错了
	    @gt = sort keys %gttime;
            @gt = grep {$_ != 0 } @gt;
	    $gt{$a}{$b}[0][0] = $gt[0];
	    $gt{$a}{$b}[0][1] = $gt[1];
	  }
	}
      } else {  #否则就是大于两个key，就是错了
	warn "$a\t$b";
	$gt{$a}{$b}[0][0] = 0;
	$gt{$a}{$b}[0][1] = 0;
      }
    }	    
  }
}

#将待打印的"行"存储进@line
my @line;
my $l = 0;
foreach my $a (sort keys %gt) {
  foreach my $c (0..3) {
    push @{$line[$l]}, $a;
    if ($c) {
      push @{$line[$l]}, $c;
    } else {
      push @{$line[$l]}, "final";
    }
    foreach my $b (sort keys %{$gt{$a}}) {
      foreach my $d (0..1) {
        push @{$line[$l]}, $gt{$a}{$b}[$c][$d];
      }
    }
  ++$l;
  }
}

#打印结果
print "#Sample ID\tRepeat\t";
print (join "\t\t", sort @locus);
print "\n";

foreach (@line) {
  print (join "\t", @{$_});
  print "\n";
}
