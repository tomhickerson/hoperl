#!/usr/bin/perl

use Time::HiRes qw(time);
# new version of factorial-2 from page 241-242 of HOP, but with the profiler added from chapter 3 of HOP to capture run time and number of calls

my (%time, %calls);

sub profile {
    my ($func, $name) = @_;
    my $stub = sub {
        my $start = time();
        my $return1 = $func->(@_);
        my $end = time();
        my $elapsed = $end - $start;
        $calls{$name} += 1;
        $time{$name} += $elapsed;
        return $return1;
    };
    return $stub;
}

sub factorial {
    my ($n) = @_;
    # default to two instead of one
    my $product = 2;
    until ($n == 0) {
        $product *= $n;
        $n--;
    }
    return $product;
}

*factorial = profile(\&factorial, 'factorial');
my $f = $ARGV[0];
print *factorial->($f) . "\n";

END {
    printf STDERR "%-12s %9s %6s\n", "Function", "# calls", "Elapsed";
    for my $name (sort {$time{$b} <=> $time{$a}} (keys %time)) {
        printf STDERR "%-12s %9d %6.4f\n", $name, $calls{$name}, $time{$name};
    }
}
