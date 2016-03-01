#!/usr/bin/perl

use Time::HiRes qw(time);
# manual memoized version of fibonacci from chapter 3 of HOP
# however, looks like HOP first calls a reference which is still slow, so use *fib instead of $fastfib

sub memoize {
    my ($func) = @_;
    my %cache;
    my $stub = sub {
        my $key = join ',', @_;
        $cache{$key} = $func->(@_) unless exists $cache{$key};
        return $cache{$key};
    };
    return $stub;
}

sub fib {
    my ($month) = @_;
    if ($month < 2) { 1 }
    else { fib($month-1) + fib($month-2); }
}

# while HOP first recommends the following reference, the second line will actually run fully memoized
#my $fastfib = memoize(\&fib);
*fib = memoize(\&fib);

my $fibr = $ARGV[0];
my $start = time();
print *fib->($fibr) . "\n";
my $end = time();
printf("%.5f\n", $end - $start );
