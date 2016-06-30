#!/usr/bin/perl

package System;
use Equation;

sub new {
    my ($base, @eqns) = @_;
    my $class = ref $base || $base;
    bless \@eqns => $class;
}

sub equations {
    my $self = shift;
    grep defined, @$self;
}

sub apply {
    my ($self, $func) = @_;
    for my $eq ($self->equations) {
        $func->($eq);
    }
}

sub solve {
    my $self = shift;
    my $N = my @E = $self->equations;
    for my $i (0 .. $N-1) {
        next unless defined $E[$i];
        my $var = $E[$i]->Equation::a_var;
        for my $j (0 .. $N-1) {
            next if $i == $j;
            next unless defined $E[$j];
            next unless $E[$j]->Equation::coefficient($var);
            $E[$j]->Equation::substitute_for($var, $E[$i]);
            if ($E[$j]->Equation::is_tautology) {
                undef $E[$j];
            } elsif ($E[$j]->Equation::is_inconsistent) {
                return;
            }
        }
    }
    $self->normalize;
    return 1;
}

sub normalize {
    my $self = shift;
    $self->apply(sub {$_[0]->Equation::normalize});
}

sub values {
    my $self = shift;
    my %values;
    $self->solve;
    for my $eqn ($self->equations) {
        if (my $name = $eqn->Equation::defines_var) {
            $values{$name} = -$eqn->Equation::constant;
        }
    }
    %values;
}

1;
