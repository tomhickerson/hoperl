#!/usr/bin/perl

# starting in on the newton sqrt function on p 302, HOP

sub close_enough {
    my ($a, $b) = @_;
    return abs($a - $b) < 1e-12;
}

sub sqrt2 {
    my $g = 2;
    # initial guess
    until (close_enough($g*$g, 2)) {
        $g = ($g * $g + 2) / (2 * $g);
        print "$g\n";
    }
    $g;
}

&sqrt2;
