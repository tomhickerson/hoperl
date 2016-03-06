#!/usr/bin/perl

use Time::HiRes qw(time);
# slow version of fibonacci from chapter 3 of HOP, but with an added profiler function

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

*fib = profile(\&fib, 'fib');
my $fibr = $ARGV[0];
print *fib->($fibr) . "\n";

END {
    printf STDERR "%-12s %9s %6s\n", "Function", "# calls", "Elapsed";
    for my $name (sort {$time{$b} <=> $time{$a}} (keys %time)) {
        printf STDERR "%-12s %9d %6.4f\n", $name, $calls{$name}, $time{$name};
    }
}
