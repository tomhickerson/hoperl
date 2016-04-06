#!/usr/bin/perl

# simple version of the sequence of Hamming numbers, from pages 269-270 of HOP
use Data::Dumper;

sub is_hamming {
    my $n = shift;
    $n/=2 while $n % 2 == 0;
    $n/=3 while $n % 3 == 0;
    $n/=5 while $n % 5 == 0;
    return $n == 1;
}

# return the first N hamming numbers
sub hamming {
    my $N = shift;
    my @hamming;
    my $t = 1;
    until (@hamming == $N) {
        push @hamming, $t if is_hamming($t);
        $t++;
    }
    @hamming;
}

print Dumper \&hamming(50);
