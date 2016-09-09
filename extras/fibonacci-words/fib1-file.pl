#!/usr/bin/perl

use Time::HiRes qw(time);
use Data::Dumper;
# new version of factorial-2 from page 241-242 of HOP, adding the time measurements, our first attempt at solving fibonacci-words

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

sub fib {
    my $n = shift;
    if ($n < 2) {
        return $n;
    } else {
        my $s1 = fib($n-1);
        my $s2 = fib($n-2);
        return $s1 . $s2;
    }
}

sub trim {
    my $s = shift;
    $s =~ s/^\s+|\s+$//g;
    return $s;
}

*fib = profile(\&fib, 'fib');
my $f = $ARGV[0];
# open the file
open my $fh, "<", $f or return;

my ($num, $pat);
my $line = 0;
my @data;
while (my $row = <$fh>) {
    # read numbers off the file into an array
    push @data, trim($row);
    # print "pushed " . trim($row) . "\n";
}

# print Dumper(@data);

while (@data) {
    $line++;
    $num = shift @data;
    $pat = shift @data;
    # print "shifted " . $num .  " and " . $pat . "\n";
    my $ans = *fib->($num);
    my $printans = $ans;
    # why do the above?  because $ans will be transformed
    my $count = $ans =~ s/$pat/$1/g;
    print "Case " . $line . ": for " . $printans . " - " . $count . "\n";
}

END {
    printf STDERR "%-12s %9s %6s\n", "Function", "# calls", "Elapsed";
    for my $name (sort {$time{$b} <=> $time{$a}} (keys %time)) {
        printf STDERR "%-12s %9d %6.4f\n", $name, $calls{$name}, $time{$name};
    }
}
