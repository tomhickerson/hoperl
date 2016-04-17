#!/usr/bin/perl

use Stream 'iterate_function';

sub sqrt_stream {
    my $n = shift;
    iterate_function ( sub { my $g = shift;
                       ($g*$g + $n) / (2 * $g);
                       }, $n);
}

sub close_enough {
    my ($a, $b) = @_;
    return abs($a - $b) < 1e-12;
}
