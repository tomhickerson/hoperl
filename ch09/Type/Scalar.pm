#!/usr/bin/perl

package Type::Scalar;
@Type::Scalar::ISA = 'Type';
sub is_scalar { 1 }

sub add_constraint {
    die "Added constraint to scalar type";
}

sub add_subfeature {
    die "Added subfeature to scalar type";
}
