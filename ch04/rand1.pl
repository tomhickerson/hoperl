#!/usr/bin/perl

# first example of random number generator from chapter 04 of HOP
# an example of bad randomness, i.e. a sequence
my $seed = 1;

sub Rand {
    $seed = (27*$seed + 11111) & 0x7fff;
    return $seed;
}

print Rand() . "\n";
print Rand() . "\n";
print Rand() . "\n";
print Rand() . "\n";
print Rand() . "\n";
