#!/usr/bin/perl

use PowSeries ':all';
use Stream 'show';

show(derivative($sin), 20);
print "\n";
show($cos, 20);

# should be the same
print "\n";

my $one = add2(multiply($cos, $cos), multiply($sin, $sin));
show($one, 20);
