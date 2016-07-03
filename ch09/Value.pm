#!/usr/bin/perl

package Value;

my %op = ("add" => {
    "FEATURE,FEATURE" => 'add_features',
    "FEATURE,CONSTANT" => 'add_feature_con',
    "FEATURE,TUPLE" => 'add_feature_tuple',
    "TUPLE,TUPLE" => 'add_tuples',
    "TUPLE,CONSTANT" => undef,
    "CONSTANT,CONSTANT" => 'add_constants',
    NAME => "Addition"
          },
          "mul" => {
              "FEATURE,CONSTANT" => 'mul_feature_con',
              "TUPLE,CONSTANT" => 'mul_tuple_con',
              "CONSTANT,CONSTANT" => 'mul_constants',
              NAME => "Multiplication"
          },

    );

sub op {
    my ($self, $op, $operand) = @_;
    my ($k1, $k2) = ($self->kindof, $operand->kindof);
    my $method;
    if ($method = $op{$op}{"$k1,$k2"}) {
        $self->method($operand);
    } elsif ($method = $op{$op}{"$k2,$k1"}) {
        $operand->method($self);
    } else {
        my $name = $op{$op}{NAME} || '$op';
        die "$name of $k1 and $k2 not defined!";
    }
}

sub negate { $_[0]->scale(-1); }

sub reciprocal { die "Nonlinear division!"; }
