#!/usr/bin/perl

package Value::Constant;

@Value::Constant::ISA = 'Value';

sub new {
    my ($base, $con) = @_;
    my $class = ref $base || $base;
    bless { WHAT => $base->kindof, VALUE => $con } => $class;
}

sub kindof { "CONSTANT" }

sub value { $_[0]{VALUE} }

sub scale {
    my ($self, $coeff) = @_;
    $self->new($coeff * $self->value);
}

sub reciprocal {
    my $self = shift;
    my $v = $self->value;
    if ($v == 0) {
        die "Division by zero";
    }
    $self->new(1/$v);
}

sub add_constants {
    my ($c1, $c2) = @_;
    $c1->new($c1->value + $c2->value);
}

sub mul_constants {
    my ($c1, $c2) = @_;
    $c1->new($c1->value * $c2->value);
}
