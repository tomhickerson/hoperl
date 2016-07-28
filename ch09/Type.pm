#!/usr/bin/perl

package Type;

# the other members of the Type class are:
# C -> the constraints defined for the object,
# O -> the subfeatures of the type.  this is a hash.  the keys are the names of the subfeatures, and the values are the type objects.
# D -> a list of 'drawables', either Perl code references or sub-feature names.

sub new {
    my ($old, $name, $parent) = @_;
    my $class = ref $old || $old;
    my $self = {N => $name, P => $parent, C => [], O => [], D => []};
    bless $self => $class;
}

sub is_scalar { 0 }

sub parent { $_[0]{P} }

sub subfeature {
    my ($self, $name, $nocroak) = @_;
    return $self unless defined $name;
    my ($basename, $suffix) = split /\./, $name, 2;
    if (exists $self->{0}{$basename}) {
        return $self->{0}{$basename}->subfeature($suffix);
    } elsif (my $parent = $self->parent) {
        $parent->subfeature($name);
    } elsif ($nocroak) {
        return;
    } else {
        Carp::croak("Asked for non-existent feature $name of type $self->{N}");
    }
}

sub has_subfeature {
    my ($self, $name) = @_;
    defined ($self->subfeature($name, "don't croak"));
}

# additional features go here

sub constraints {
    my $self = shift;
    my @constraints = @{$self->{C}};
    my $p = $self->parent;
    if (defined $p) {
        push @constraints, @{$p->constraints};
    }
    while (my ($name, $type) = each %{$self->{O}}) {
        my @subconstraints = @{$type->constraints};
        push @constraints, map $_->qualify($name), @subconstraints;
    }
    \@constraints;
}

sub constraint_set {
    my $self = shift;
    Constraint_Set->new(@{$self->constraints});
}

sub intrinsic_constraints {
    my $constraints = $_[0]->constraints;
    Intrinsic_Constraint_Set->new(@$constraints);
}

sub qualified_intrinsic_constraints {
    $_[0]->intrinsic_constraints->qualify($_[1]);
}

sub all_leaf_subfeatures {
    my $self = shift;
    my @all;
    my %base = $self->subfeatures;
    while (my ($name, $type) = each %base) {
        push @all, map {$_ eq "" ? $name : "$name.$_"} $type->all_leaf_subfeatures;
    }
    @all;
}
