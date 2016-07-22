#!/usr/bin/perl

package Value::Feature;
@Value::Feature::ISA = 'Value';

sub kindof { "FEATURE" }

sub new {
    my ($base, $intrinsic, $synthetic) = @_;
    my $class = ref $base || $base;
    my $self = {WHAT => $base->kindof, SYNTHETIC => $synthetic, INTRINSIC => $intrinsic};
    bless $self => $class;
}

sub new_from_var {
    my ($base, $name, $type) = @_;
    my $class = ref $base || $base;
    $base->new($type->qualified_intrinsic_constraints($name), $type->qualified_synthetic_constraints($name),);
}

sub intrinsic { $_[0]->{INTRINSIC}}
sub synthetic { $_[0]->{SYNTHETIC}}
