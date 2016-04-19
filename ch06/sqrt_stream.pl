#!/usr/bin/perl

use Stream 'iterate_function', 'show', 'head';

sub sqrt_stream {
    my $n = shift;
    iterate_function ( sub { my $g = shift;
                       ($g*$g + $n) / (2 * $g);
                       }, $n);
}

my $n = 2;
my $g2 = $n;
show(sqrt_stream($g2, $n), 5);
