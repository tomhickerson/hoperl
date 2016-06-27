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
