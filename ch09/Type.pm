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
