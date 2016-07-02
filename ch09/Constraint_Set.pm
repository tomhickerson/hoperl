#!/usr/bin/perl

package Constraint_Set;
@Constraint_Set::ISA = 'System';

sub constraints {
    my $self = shift;
    $self->equations;
}

1;
