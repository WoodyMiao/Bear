#!/usr/bin/perl
use strict;
use warnings;

open O, ">", "result_harvest.txt";
my ($l1, $l2, $l3, $l4, @a);

open I1, "-|", "cat 2.Minshan/*_a_*";
print O "Minshan\r\n";
foreach (1..3) {
$l1 = <I1>;
$l2 = <I1>;
$l3 = <I1>;
$l4 = <I1>;
print O $l1;
@a = split /  /, $l4;
print O join("\t", @a);}
close I1;

open I2, "-|", "cat 3.Tangjiahe/*_a_*";
print O "\r\nTangjiahe\r\n";
foreach (1..3) {
$l1 = <I2>;
$l2 = <I2>;
$l3 = <I2>;
$l4 = <I2>;
print O $l1;
@a = split /  /, $l4;
print O join("\t", @a);}
close I2;

open I3, "-|", "cat 4.Wanglang/*_a_*";
print O "\r\nWanglang\r\n";
foreach (1..3) {
$l1 = <I3>;
$l2 = <I3>;
$l3 = <I3>;
$l4 = <I3>;
print O $l1;
@a = split /  /, $l4;
print O join("\t", @a);}
close I3;

open I4, "-|", "cat 5.Xuebaoding/*_a_*";
print O "\r\nXuebaoding\r\n";
foreach (1..3) {
$l1 = <I4>;
$l2 = <I4>;
$l3 = <I4>;
$l4 = <I4>;
print O $l1;
@a = split /  /, $l4;
print O join("\t", @a);}
close I4;
close O;
