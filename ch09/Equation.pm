#!/usr/bin/perl

# Equation, starting to fill in the linogram assignment in section 9.4 of HOP

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
