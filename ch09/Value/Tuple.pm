#!/usr/bin/perl

package Value::Tuple;
@Value::Tuple::ISA = 'Value';

sub kindof { "TUPLE" }

sub new {
    my ($base, %tuple) = @_;
    my $class = ref $base || $base;
    bless { WHAT => $base->kindof, TUPLE => \%tuple} => $class;
}

sub components { keys %{$_[0]{TUPLE}}}

sub has_component { exists $_[0]{TUPLE}{$_[1]}}

sub component { $_[0]{TUPLE}{$_[1]}}

sub to_hash { $_[0]{TUPLE}}
