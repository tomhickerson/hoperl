#!/usr/bin/perl

package Synthetic_Constraint_Set;

sub new {
    my $base = shift;
    my $class = ref $base || $base;
    my $constraints;
    if (@_ == 1) {
        $constraints = shift;
    } elsif (@_ % 2 == 0) {
        my %constraints = @_;
        $constraints = \%constraints;
    } else {
        my $n = @_;
        require Carp;
        Carp::croak("$n requirements to SCS::new");
    }
    bless $constraints => $class;
}

sub constraints { values %{$_[0]}}
sub constraint { $_[0]->{$_[1]}}
sub labels { keys %{$_[0]}}
sub has_label { exists $_[0]->{$_[1]} }

sub add_labeled_constraint {
    my ($self, $label, $constraint) = @_;
    $self->{$label} = $constraint;
}

sub apply {
    my ($self, $func) = @_;
    my %result;
    for my $k ($self->$labels) {
        $result{$k} = $func->($self->constraint($k));
    }
    $self->new(\%result);
}
