#!/usr/bin/perl

use Time::HiRes qw(time);
# using the inline caching function from chapter 3 of HOP, getting to fix the fibonacci function

{
    my %cache;
    sub fib {
        my ($month) = @_;
        unless (exists $cache{$month}) {
            if ($month < 2) { $cache{$month} = 1; }
            else { $cache{$month} = fib($month-1) + fib($month-2); }
        }
        return $cache{$month};
    }
}

my $fibr = $ARGV[0];
my $start = time();
print fib($fibr) . "\n";
my $end = time();
printf("%.5f\n", $end - $start );
