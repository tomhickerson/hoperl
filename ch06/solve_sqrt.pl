#!/usr/bin/perl

use Stream 'show', 'iterate_function';

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

my $sqrt2 = solve(sub { $_[0] * $_[0] - 2});

{
    local $" = "\n";
    show($sqrt2, 10);
}
