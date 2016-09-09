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
    my ($s1, $s2, $return);
    my $BRANCH = 0;
    my @STACK;
    while (1) {
        if ($n == 0) {
            $return = "0";
        } elsif ($n == 1) {
            $return = "1";
        } else {
            if ($BRANCH == 0) {
                push @STACK, [$BRANCH, $s1, $s2, $n];
                $n -= 2;
                $BRANCH = 0;
                next;
            } elsif ($BRANCH == 1) {
                $s1 = $return;
                push @STACK, [$BRANCH, $s1, $s2, $n];
                $n -= 1;
                $BRANCH = 0;
                next;
            } elsif ($BRANCH == 2) {
                $s2 = $return;
                $return = $s2 . $s1;
            }
        }
        return $return unless @STACK;
        ($BRANCH, $s1, $s2, $n) = @{pop @STACK};
        $BRANCH++;
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
    my $count = 0;
    while ($ans =~ /(?=$pat)/g) {
        $count++;
    }
    print "Case " . $line . ": " . $count . "\n";
}

END {
    printf STDERR "%-12s %9s %6s\n", "Function", "# calls", "Elapsed";
    for my $name (sort {$time{$b} <=> $time{$a}} (keys %time)) {
        printf STDERR "%-12s %9d %6.4f\n", $name, $calls{$name}, $time{$name};
    }
}
