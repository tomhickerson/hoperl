#!/usr/bin/perl

# second example of random numbers, this time with an iterator class

use Iterator_Utils;

sub make_rand {
    my $seed = shift || (time & 0x7fff);
    return Iterator_Utils::Iterator {
        $seed = (29 * $seed + 11111) & 0x7fff;
        return $seed;
    };
}

my $rng = make_rand();

for (1..20) {
    my $random = Iterator_Utils::NEXTVAL($rng);
    print $random . " " . $random/32768 . "\n";
}
