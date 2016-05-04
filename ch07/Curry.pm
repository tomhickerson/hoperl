#!/usr/bin/perl

package Curry;
use base 'Exporter';
@EXPORT = ('curry');
@EXPORT_OK = qw(curry_listfunc curry_n);

sub curry {
    my $f = shift;
    return sub {
        my $first_arg = shift;
        my $r = sub { $f->($first_arg, @_)};
        return @_ ? $r->(@_) : $r;
    };
}

sub curry_listfunc {
    my $f = shift;
    return sub {
        my $first_arg = shift;
        return sub { $f->($first_arg, @_)};
    };
}

1;
