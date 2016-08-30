#!/usr/bin/perl

use Stream 'transform', 'promise', 'show', 'upfrom';

# dijkstra_primes, a slight departure from the chapter 06 curriculum

sub is_prime {
    my $n = $_[0];
    my $p = {2};
    my $q = { };
    my $x = 1;
    my $limit = 4;
    my &has_prime = sub {

    }
    while ($p < $n) {
        unless &has_prime->($x) {

        }
        $x = $x + 2;
        if ($x >= $limit) {

        }
    }
}

my $primes = transform \&is_prime, upfrom(1);
show($primes, 100);
