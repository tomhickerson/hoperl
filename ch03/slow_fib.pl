#!/usr/bin/perl

use Time::HiRes qw(time);
# slow version of fibonacci from chapter 3 of HOP, will fix this in caching


sub fib {
        my ($month) = @_;
        if ($month < 2) { 1 }
        else { fib($month-1) + fib($month-2); }
}


my $fibr = $ARGV[0];
my $start = time();
print fib($fibr) . "\n";
my $end = time();
printf("%.5f\n", $end - $start );
