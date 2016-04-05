#$a = <>;
#while (!$a =~ m/^#Sequences whose/) {
#	$a = <>;
#}

while (<>) {
	chomp;
	s/>//;
	$/ = ">";
	$s = <>;
	chomp;
	s/\s//;
	$/ = "\n";
	$len = length $s;
	$l = @{[$s =~ m/A|T|C|G/g]};
	print "$_\t$l\n";
	++$c{$l};
}

foreach (sort {$a <=> $b} keys %c) {
       print "$_\t$c{$_}\n";
}       
print "$len\n";
