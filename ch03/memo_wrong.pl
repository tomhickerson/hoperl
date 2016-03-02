#!/usr/bin/perl

# an example of memoization from chapter 3 of HOP, where it can go wrong

use Memoize;

sub iota {
    my $n = shift;
    return [1..$n];
}

memoize 'iota';

$i10 = iota(10);
$j10 = iota(10);
pop @$i10;
print @$j10 . "\n";
pop @$i10;
print @$j10 . "\n";
pop @$i10;
print @$j10 . "\n";


# unfortunately, i10 and j10 are now linked, and anything happening to i10, happens to j10 as well, thanks to memoization
