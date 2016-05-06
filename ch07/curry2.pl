#!/usr/bin/perl

# first example of using the Currying module

use Curry 'curry_n';

*add = curry_n(2, sub { $_[0] + $_[1]});
print(add(2,3) . "\n");
*increment = add(1);
print(increment(8) . "\n");

# a little more interesting, now looking at substrings

*csubstr = curry_n(3, sub { defined $_[3] ? substr($_[0], $_[1], $_[2], $_[3]) : substr($_[0], $_[1], $_[2])});
my $target = "I like pie";
my $first_N_chars = csubstr($target, 0);
my $prefix_3 = $first_N_chars->(3);
my $prefix_5 = $first_N_chars->(5);

print $prefix_3 . "\n";
print $prefix_5 . "\n";
