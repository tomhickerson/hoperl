#!/usr/bin/perl

# Hamming numbers done with merging and streaming, per pages 271-272 of HOP

use Stream qw(transform promise merge node show);

sub scale {
    my ($s, $c) = @_;
    transform { $_[0] * $c } $s;
}

my $hamming;
$hamming = node(1, promise {
                merge(scale($hamming, 2),
                    merge(scale($hamming, 3), scale($hamming, 5))
                    )}
    );

show($hamming, 3000);
