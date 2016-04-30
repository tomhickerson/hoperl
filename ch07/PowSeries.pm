#!/usr/bin/perl

# power series functions, from chapter 06 of HOP

package PowSeries;
use base 'Exporter';
@EXPORT_OK = qw(add2 mul2 partial_sums powers_of term_values evaluate derivative multiply recip divide $add2 $mul2 $sin $cos $exp $log_ $tan);
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

sub combine2 {
    my $op = shift;
    return sub {
        my ($s, $t) = @_;
        return unless $s && $t;
        node($op->(head($s), head($t)),
             promise { combine2($op)->(tail($s),tail($t))});
    };
}

$add2 = combine2(sub {$_[0] + $_[1] });

$mul2 = combine2(sub {$_[0] * $_[1] });


sub partial_sums {
    my $s = shift;
    my $t;
    $t = node(head($s), promise { $add2->($t, tail($s))});
}

sub powers_of {
    my $x = shift;
    my $func = iterate_function(sub {$_[0] * $x});
    $func->(1);
}

sub term_values {
    my ($s, $x) = @_;
    $mul2->($s, powers_of($x));
}

sub evaluate {
    my ($s, $x) = @_;
    partial_sums(term_values($s, $x));
}

sub derivative {
    my $s = shift;
    $mul2->(upfrom(1), tail($s));
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

sub sum {
    my @s = grep $_, @_;
    my $total = 0;
    $total += head($_) for @s;
    node($total, promise { sum(map tail($_), @s)});
}

sub multiply {
    my ($S, $T) = @_;
    my ($s, $t) = (head($S), head($T));
    node($s*$t, promise { sum(scale(tail($T), $s), scale(tail($S), $t),
                               node(0, promise { multiply(tail($S),
                                                          tail($T))}),
                               )
         });
}

sub recip {
    my ($s) = shift;
    my $r;
    $r = node(1, promise { scale(multiply($r, tail($s)), -1) });
}

sub divide {
    my ($s, $t) = @_;
    multiply($s, recip($t));
}

$tan = divide($sin, $cos);
