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
