#!/usr/bin/perl

use Time::HiRes qw(time);
use Memoize;
# automatically memoized version of fibonacci from chapter 3 of HOP, no caching required

memoize 'fib';
sub fib {
        my ($month) = @_;
        if ($month < 2) { $month }
        else { fib($month-1) + fib($month-2); }
}


my $fibr = $ARGV[0];
my $start = time();
print fib($fibr) . "\n";
my $end = time();
printf("%.5f\n", $end - $start );
