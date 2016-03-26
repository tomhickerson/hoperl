#!/usr/bin/perl

# a simpler version of the partition problem from p 218 of HOP
# we're taking a step back and returning a simpler result than the earlier examples

sub partition {
    print "@_\n";
    my ($n, @parts) = @_;
    for (1..$n-1) {
        partition($n-$_, $_, @parts);
    }
}

partition(7);
