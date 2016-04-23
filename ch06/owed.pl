#!/usr/bin/perl

use Stream 'cut_loops', 'drop', 'iterate_function';

# how much do I owe?  example from Chapter 06 of HOP

sub owed {
    my ($P, $N, $pmt, $i) = @_;
    return $P * (1+$i)**$N - $pmt * ((1+$i)**$N - 1) / $i;
}

sub owed_after_n_months {
    my $N = shift;
    owed(100000, $N, 1000, 0.005);
}

# copying the following from the sqrt problem
sub slope {
    my ($f, $x) = @_;
    my $e = 0.00000095367431640625;
    ($f->($x+$e) - $f->($x-$e)) / (2*$e);
}

sub solve {
    my $f = shift;
    my $guess = shift || 1;
    iterate_function(sub { my $g = shift;
                     $g - $f->($g)/slope($f, $g);
                     }, $guess);
}

my $stream = cut_loops(solve(\&owed_after_n_months));

my $n;
$n = drop($stream) while $stream;
print "You will be paid off in only $n months\n";
