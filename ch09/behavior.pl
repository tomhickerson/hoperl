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
        Node->new('Adder', $adder, { A1 => $a1, A2 => $a2, S => $s });
    }
}

{
    my $multiplier = sub {
        my ($self, %v) = @_;
        if (defined $v{F1} && defined $v{F2}) {
            $self->set_wire('P', $v{F1} * $v{F2});
        } elsif (defined $v{F1} && $v{F1} == 0) {
            $self->set_wire('P', 0);
        } elsif (defined $v{F2} && $v{F2} == 0) {
            $self->set_wire('P', 0);
        } else {
            $self->revoke_wire('P');
        }
        if (defined $v{F1} && defined $v{P}) {
            if ($v{F1} != 0) {
                $self->set_wire('F2', $v{P} / $v{F1});
            } elsif ($v{P} != 0) {
                warn "Division by zero\n";
            }
        } else {
            $self->revoke_wire('F2');
        }
        if (defined $v{F2} && defined $v{P}) {
            if ($v{F2} != 0) {
                $self->set_wire('F1', $v{P} / $v{F2});
            } elsif ($v{P} != 0) {
                warn "Division by zero\n";
            }
        } else {
            $self->revoke_wire('F1')
        }
    };
    sub new_multiplier {
        my ($f1, $f2, $p) = @_;
        Node->new('Multiplier', $multiplier, { F1 => $f1, F2 => $f2, P => $p});
    }
}

sub new_subtractor {
    my ($s, $m, $d) = @_;
    new_adder($d, $m, $s);
}

sub new_divider {
    my ($v, $s, $q) = @_;
    new_multiplier($q, $s, $v);
}

sub new_constant {
    my ($val, $w) = @_;
    my $node = Node->new('Constant', sub {}, {W => $w} );
    $w->set($node, $val);
    $node;
}

# we handle input and output with the announce and IO methods
{
    my $announce = sub {
        my $name = shift;
        sub {
            my ($self, %val) = @_;
            my $v = $val{W};
            if (defined $v) {
                print "$name: $v\n";
            } else {
                print "$name: no longer defined\n";
            }
        };
    };
    sub new_io {
        my ($name, $w) = @_;
        Node->new('Io', $announce->($name), { W => $w });
    }
}

sub input {
    my ($self, $value) = @_;
    $self->wire('W')->set($self, $value);
}

sub revoke {
    my $self = shift;
    $self->wire('W')->revoke($self);
}

# next step: create the local propagation network
# it's important to check the errata page, as we get funky output
my ($F, $C);
{
    my ($i, $j, $k, $l, $m) = Wire->make(5);
    $F = new_io('Fahrenheit', $j);
    $C = new_io('Celsius', $m);
    new_constant(32, $i);
    new_constant(5/9, $l);
    new_adder($i, $k, $j);
    new_multiplier($k, $l, $m);
}

input($F, 212);
input($F, 32);
revoke($F);
input($C, 37);
input($F, 100);
revoke($C);
input($F, 100);
