#!/usr/bin/perl

# another version of the simple partitioning program, this time with min and max

sub partition {
    print "@_\n";
    my ($largest, @rest) = @_;
    my $min = $rest[0] || 1;
    my $max = int($largest/2);
    for ($min..$max) {
        partition($largest-$_, $_, @rest);
    }
}

partition(7);
