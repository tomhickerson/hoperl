#!/usr/bin/perl

package Value::Feature;
@Value::Feature::ISA = 'Value';

sub kindof { "FEATURE" }

sub new {
    my ($base, $intrinsic, $synthetic) = @_;
    my $class = ref $base || $base;
    my $self = {WHAT => $base->kindof, SYNTHETIC => $synthetic, INTRINSIC => $intrinsic};
    bless $self => $class;
}

sub new_from_var {
    my ($base, $name, $type) = @_;
    my $class = ref $base || $base;
    $base->new($type->qualified_intrinsic_constraints($name), $type->qualified_synthetic_constraints($name),);
}

sub intrinsic { $_[0]->{INTRINSIC}}
sub synthetic { $_[0]->{SYNTHETIC}}

sub scale {
    my ($self, $coeff) = @_;
    return $self->new($self->intrinsic, $self->synthetic->scale($coeff));
}

sub add_features {
    my ($o1, $o2) = @_;
    my $intrinsic = $o1->intrinsic->union($o2->intrinsic);
    my $synthetic = $o1->synthetic->apply2($o2->synthetic, sub {$_[0]->add_equations($_[1])}, );
}

sub mul_feature_con {
    my ($o, $c) = @_;
    $o->scale($c->value);
}

sub add_feature_con {
    my ($o, $c) = @_;
    my $v = $c->value;
    my $synthetic = $o->synthetic->apply(sub { $_[0]->add_constant($v) });
    $o->new($o->intrinsic, $synthetic);
}

sub add_feature_tuple {
    my ($o, $t) = @_;
    my $synthetic = $o->synthetic->apply_hash($t->to_hash,
        sub { my ($constr, $comp) = @_;
                                              my $kind = $comp->kindof;
                                              if ($kind eq "CONSTANT") {
                                                  $constr->add_constant($comp->value);
                                              } elsif ($kind eq "FEATURE") {
                                                  $constr->add_equations($comp->synthetic->constraint(""));
                                              } elsif ($kind eq "TUPLE") {
                                                  die "Tuple with subtuple component!";
                                              } else {
                                                  die "Unknown tuple component $kind!";
                                              }},
        );
    $o->new($o->intrinsic, $synthetic);
}

1;
