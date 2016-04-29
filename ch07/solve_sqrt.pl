#!/usr/bin/perl

# changing the code to allow for currying in chapter 07

use Stream 'show', 'iterate_function', 'cut_loops';

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

my $sqrt2 = solve(sub { $_[0] * $_[0] - 2});

{
    local $" = "\n";
    show(cut_loops($sqrt2));
}
