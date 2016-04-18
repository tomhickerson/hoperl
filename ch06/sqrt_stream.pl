#!/usr/bin/perl

use Stream 'iterate_function', 'show', 'head';

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

my $n = 2;
my $g2 = $n;

until (close_enough($g2*$g2, $n)) {
    $g2 = head(sqrt_stream($n, $g2));
    print "$g2\n";
}
