#!/usr/bin/perl

# behavior, capturing the adding, subtracting, etc from Node and Wire in Chapter 09 of HOP

use Node;
use Wire;

{
    my $adder = sub {
        my ($self, %v) = @_;
        if (defined $v{A1} && defined $v{A2}) {
            $self->set_wire('S', $v{A1} + $v{A2});
        } else {
            $self->revoke_wire('S');
        }
        if (defined $v{A1} && defined $v{S}) {
            $self->set_wire('A2', $v{S} - $v{A1});
        } else {
            $self->revoke_wire('A2');
        }
        if (defined $v{A2} && defined $v{S}) {
            $self->set_wire('A1', $v{S} - $v{A2});
        } else {
            $self->revoke_wire('A1');
        }
    };
    sub new_adder {
        my ($a1, $a2, $s) = @_;
        Node->new('adder', $adder, { A1 => $a1, A2 => $a2, S => $s });
    }
}
