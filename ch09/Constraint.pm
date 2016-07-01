#!/usr/bin/perl

package Constraint;
use Equation;
@Constraint::ISA = 'Equation';

sub qualify {
    my ($self, $prefix) = @_;
    my %result = ("" => $self->constant);
    for my $var ($self->varlist) {
        $result{"$prefix.$var"} = $self->coefficient($var);
    }
    $self->new(%result);
}

sub new_constant {
    my ($base, $val) = @_;
    my $class = ref $base || $base;
    $class->new("" => $val);
}

sub add_constant {
    my ($self, $v) = @_;
    $self->add_equations($self->new_constant($v));
}

sub mul_constant {
    my ($self, $v) = @_;
    $self->scale_equation($v);
}
