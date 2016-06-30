#!/usr/bin/perl

# Equation, starting to fill in the linogram assignment in section 9.4 of HOP
package Equation;

sub new {
    my ($base, %self) = @_;
    $class = ref($base) || $base;
    $self{""} = 0 unless exists $self{""};
    for my $k (keys %self) {
        if ($self{$k} == 0 && $k ne "") { delete $self{$k}}
    }
    bless \%self => $class;
}

sub duplicate {
    my $self = shift;
    $self->new(%$self);
}

sub coefficient {
    my ($self, $name) = @_;
    $self->{$name} || 0;
}

sub constant {
    $_[0]->coefficient("");
}

sub varlist {
    my $self = shift;
    grep $_ ne "", keys %$self;
}

# added from errata, to account for floating-point craziness
my $EPSILON = 1e-6;

sub arithmetic {
    my ($a, $ac, $b, $bc) = @_;
    my %new;
    for my $k (keys(%$a), keys %$b) {
        my ($av) = $a->coefficient($k);
        my ($bv) = $b->coefficient($k);
        my $new = $ac * $av + $bc * $bv;
        $new{$k} = abs($new) < $EPSILON ? 0 : $new;
    }
    $a->new(%new);
}

sub add_equations {
    my ($a, $b) = @_;
    arithmetic($a, 1, $b, 1);
}

sub subtract_equations {
    my ($a, $b) = @_;
    arithmetic($a, 1, $b, -1);
}

# was $Zero, but not sure about that one
sub scale_equation {
    my ($a, $c) = @_;
    arithmetic($a, $c, 0, 0);
}

# labeled in the book as Destructive, since it modified $self in place
sub substitute_for {
    my ($self, $var, $value) = @_;
    my $a = $self->coefficient($var);
    return if $a == 0;
    my $b = $value->coefficient($var);
    die "Should not occur!" if $b == 0; # should not occur
    my $result = arithmetic($self, 1, $value, -$a/$b);
    %$self = %$result;
}

sub a_var {
    my $self = shift;
    my ($var) = $self->varlist;
    $var;
}

# this is the part of the book where we move back and forth between packages, and so I'm adding where I see it fits best.
sub is_tautology {
    my $self = shift;
    return $self->constant == 0 && $self->varlist == 0;
}

sub is_inconsistent {
    my $self = shift;
    return $self->constant != 0 && $self->varlist == 0;
}

sub normalize {
    my $self = shift;
    my $var = $self->a_var;
    return unless defined $var;
    %$self = %{$self->scale_equation(1/$self->coefficient($var))};
}

sub defines_var {
    my $self = shift;
    my @keys = keys %$self;
    return unless @keys == 2;
    my $var = $keys[0] || $keys[1];
    return $self->{$var} == 1 ? $var : 0;
}
