#!/usr/bin/perl

package Intrinsic_Constraint_Set;

sub new {
    my ($base, @constraints) = @_;
    my $class = ref $base || $base;
    bless \@constraints => $class;
}

sub constraints { @{$_[0]} }

sub apply {
    my ($self, $func) = @_;
    my @c = map $func->($_), $self->constraints;
    $self->new(@c);
}

sub qualify {
    my ($self, $prefix) = @_;
    $self->apply(sub { $_[0]->qualify($prefix)});
}

sub union {
    my ($self, @more) = @_;
    $self->new($self->constraints, map {$_->constraints} @more);
}
