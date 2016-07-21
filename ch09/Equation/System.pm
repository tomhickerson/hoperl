#!/usr/bin/perl

package Equation::System;

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
        my $var = $E[$i]->a_var;
        for my $j (0 .. $N-1) {
            next if $i == $j;
            next unless defined $E[$j];
            next unless $E[$j]->coefficient($var);
            $E[$j]->substitute_for($var, $E[$i]);
            if ($E[$j]->is_tautology) {
                undef $E[$j];
            } elsif ($E[$j]->is_inconsistent) {
                return;
            }
        }
    }
    $self->normalize;
    return 1;
}

sub normalize {
    my $self = shift;
    $self->apply(sub {$_[0]->normalize});
}

sub values {
    my $self = shift;
    my %values;
    $self->solve;
    for my $eqn ($self->equations) {
        if (my $name = $eqn->defines_var) {
            $values{$name} = -$eqn->constant;
        }
    }
    %values;
}

1;
