#!/usr/bin/perl

# first test of the power series package from chapter 06 of HOP

use PowSeries ':all';
use Stream ':all';

# get the nth term from a stream
sub nth {
    my $s = shift;
    my $n = shift;
    return $n == 0 ? head($s) : nth(tail($s), $n-1);
}

sub cosine {
    my $x = shift;
    nth(evaluate($cos, $x), 20);
}

sub is_zero_when_x_is_pi {
    my $x = shift;
    my $c = cosine($x/6);
    $c * $c - 3/4;
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

my $pi = 3.1415926535897932;
show(evaluate($cos, $pi/6), 20);
print "\n\n";
show(solve(\&is_zero_when_x_is_pi), 20);
