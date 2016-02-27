#!/usr/bin/perl

use Time::HiRes qw(time);

# generate a slow version of RGB to CYMK, as part of the caching and memoization chapter of HOP

sub RGB_to_CYMK {
    my ($r, $g, $b) = @_;
    my ($c, $m, $y) = (255-$r, 255-$g, 255-$b);
    my $k = $c < $m ? ($c < $y ? $c : $y) : ($m < $y ? $m : $y);
    for ($c, $m, $y) { $_ -= $k}
    return "$c $y $m $k";
}

my $start = time();

print (RGB_to_CYMK(184, 90, 64) . "\n");
print (RGB_to_CYMK(184, 90, 64) . "\n");
print (RGB_to_CYMK(184, 90, 64) . "\n");
print (RGB_to_CYMK(184, 90, 64) . "\n");
print (RGB_to_CYMK(184, 90, 64) . "\n");
print (RGB_to_CYMK(184, 90, 64) . "\n");
print (RGB_to_CYMK(184, 90, 64) . "\n");
print (RGB_to_CYMK(184, 90, 64) . "\n");
print (RGB_to_CYMK(184, 90, 64) . "\n");
print (RGB_to_CYMK(184, 90, 64) . "\n");
print (RGB_to_CYMK(184, 90, 64) . "\n");
print (RGB_to_CYMK(184, 90, 64) . "\n");
print (RGB_to_CYMK(184, 90, 64) . "\n");
print (RGB_to_CYMK(184, 90, 64) . "\n");
print (RGB_to_CYMK(184, 90, 64) . "\n");

my $end = time();

printf("%.2f\n", $end - $start );
