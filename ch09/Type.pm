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
