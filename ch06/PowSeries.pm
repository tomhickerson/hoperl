#!/usr/bin/perl

# power series functions, from chapter 06 of HOP

package PowSeries;
use base 'Exporter';
@EXPORT_OK = qw(add2 mul2 partial_sums powers_of term_values evaluate derivative multiply recip divide $sin $cos $exp $log_ $tan);
%EXPORT_TAGS = ('all' => \@EXPORT_OK);
use Stream ':all';

sub tabulate {
    my $f = shift;
    &transform($f, upfrom(0));
}

my @fact = (1);

sub factorial {
    my $n = shift;
    return $fact[$n] if defined $fact[$n];
    $fact[$n] = $n * factorial($n-1);
}

$sin = tabulate(sub { my $N = shift;
                      return 0 if $N % 2 == 0;
                      my $sign = int($N/2) % 2 ? -1 : 1;
                      $sign/factorial($N);
                });
$cos = tabulate(sub { my $N = shift;
                      return 0 if $N % 2 != 0;
                      my $sign = int($N/2) % 2 ? -1 : 1;
                      $sign/factorial($N);
                });

sub add2 {
    my ($s, $t) = @_;
    return $s unless $t;
    return $t unless $s;
    node(head($s) + head($t), promise{ add2(tail($s), tail($t))});
}

sub mul2 {
    my ($s, $t) = @_;
    return unless $s && $t;
    node(head($s) * head($t), promise{ mul2(tail($s), tail($t))});
}

sub partial_sums {
    my $s = shift;
    my $t;
    $t = node(head($s), promise { add2($t, tail($s))});
}

sub powers_of {
    my $x = shift;
    iterate_function(sub {$_[0] * $x}, 1);
}

sub term_values {
    my ($s, $x) = @_;
    mul2($s, powers_of($x));
}

sub evaluate {
    my ($s, $x) = @_;
    partial_sums(term_values($s, $x));
}

sub derivative {
    my $s = shift;
    mul2(upfrom(1), tail($s));
}

$exp = tabulate(sub { my $N = shift; 1/factorial($N) });

$log_ = tabulate(sub { my $N = shift;
                       $N == 0 ? 0 : (-1)**$N/-$N });

sub scale {
    my ($s, $c) = @_;
    return if $c == 0;
    return $s if $c == 1;
    transform { $_[0]*$c } $s;
}

sub multiply {
    my ($S, $T) = @_;
    my ($s, $t) = (head($S), head($T));
    node($s*$t, promise { add2(scale(tail($T), $s),
                          add2(scale(tail($S), $t),
                               node(0, promise { multiply(tail($S),
                                                          tail($T))}),
                               ))
         });
}
