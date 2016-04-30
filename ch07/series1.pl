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
# changing to replace code for chapter 07, currying

sub slope {
    my $f = shift;
    my $e = 0.00000095367431640625;
    my $d = sub {
        my $x = shift;
        ($f->($x+$e) - $f->($x-$e)) / (2*$e);
    };
    return @_ ? $d->(shift) : $d;
}

sub solve {
    my $f = shift;
    my $guess = shift || 1;
    my $func = iterate_function(sub { my $g = shift;
                           my $func = slope($f);
                     $g - $f->($g)/$func->($g);
                     });
    $func->($guess);
}

my $pi = 3.1415926535897932;
show(evaluate($cos, $pi/6), 20);
print "\n\n";
show(solve(\&is_zero_when_x_is_pi), 20);
