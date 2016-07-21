#!/usr/bin/perl

package Value::Tuple;
@Value::Tuple::ISA = 'Value';

# from chapter 09 of HOP; establish the Tuple subclass of Value.

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

sub scale {
    my ($self, $coeff) = @_;
    my %new_tuple;
    for my $k ($self->components) {
        $new_tuple{$k} = $self->component($k)->scale($coeff);
    }
    $self->new(%new_tuple);
}

sub has_same_components_as {
    my ($t1, $t2) = @_;
    my %t1c;
    for my $c ($t1->components) {
        return unless $t2->has_component($c);
        $t1c{$c} = 1;
    }
    for my $c ($t2->components) {
        return unless $t1c{$c};
    }
    return 1;
}

sub add_tuples {
    my ($t1, $t2) = @_;
    croak("Nonconformable tuples") unless $t1->has_same_components_as($t2);
    my %result;
    for my $c ($t1->components) {
        $result{$c} = $t1->component($c) + $t2->component($c);
    }
    $t1->new(%result);
}

sub mul_tuple_con {
    my ($t, $c) = @_;
    $t->scale($c->value);
}
