#!/usr/bin/perl

package Curry;
use base 'Exporter';
use Scalar::Util 'set_prototype';
@EXPORT = ('curry');
@EXPORT_OK = qw(curry_listfunc curry_n);

sub curry {
    my $f = shift;
    my $PROTOTYPE = shift;
    set_prototype(sub {
        my $first_arg = shift;
        my $r = sub { $f->($first_arg, @_)};
        return @_ ? $r->(@_) : $r;
                  }, $PROTOTYPE);
}

sub curry_listfunc {
    my $f = shift;
    return sub {
        my $first_arg = shift;
        return sub { $f->($first_arg, @_)};
    };
}

sub curry_n {
    my $N = shift;
    my $f = shift;
    my $c;
    $c = sub {
        if (@_ >= $N) {
            $f->(@_);
        } else {
            my @a = @_;
            curry_n($N-@a, sub {$f->(@a, @_)});
        }
    };
}

1;
