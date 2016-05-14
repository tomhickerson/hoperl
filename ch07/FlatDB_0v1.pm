#!/usr/bin/perl

# FlatDB 0v1, where we test out operator overloading

package FlatDB_0v1;
use base 'FlatDB_Compose';
BEGIN {
    for my $f (qw(and or without)) {
        *{"query_$f"} = \&{"FlatDB_Compose::query_$f"};
    }
}

sub query {
    $self = shift;
    my $q = $self->SUPER::query(@_);
    bless $q => __PACKAGE__;
}

sub callbackquery {
    $self = shift;
    my $q = $self->SUPER::callbackquery(@_);
    bless $q => __PACKAGE__;
}

1;
