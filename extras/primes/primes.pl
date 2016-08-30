#!/usr/bin/perl

use Stream 'node', 'transform', 'promise', 'show', 'upfrom';

# dijkstra_primes, a slight departure from the chapter 06 curriculum

sub is_prime {

}

sub prime {
    my ($s, $c) = @_;
    transform \&is_prime, $s;
}

my $primes;
$primes = transform \&is_prime, upfrom(1);
show($primes, 100);
