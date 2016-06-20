#!/usr/bin/perl

# creation of Wire.pm, the first part of our propagation framework

package Wire;

my $N = 0;

sub new {
    my ($class, $name) = @_;
    $name ||= "wire" . ++$N;
    bless { N => $name, S => undef, V => undef, A => [] } => $class;
}

sub make {
    my $class = shift;
    my $N = shift;
    my @wires;
    push @wires, $class->new while $N--;
    @wires;
}

sub set {
    my ($self, $settor, $value) = @_;
    if (!$self->has_settor || $self->settor_is($settor)) {
        $self->{V} = $value;
        $self->{S} = $settor;
        $self->notify_all_but($settor, $value);
    } elsif ($self->has_settor) {
        unless ($value == $self->value) {
            my $v = $self->value;
            my $N = $self->name;
            warn "Wire $N has inconsistent value ($value != $v)\n";
        }
    }
}

sub notify_all_but {
    my ($self, $exception, $value) = @_;
    for my $node ($self->attachments) {
        next if $node == $exception;
        $node->notify;
    }
}
