#!/usr/bin/perl

# the Regex package, from chapter 06 of HOP

package Regex;
use Stream ':all';
use base 'Exporter';
@EXPORT_OK = qw(literal union concat star plus charclass show matches);

sub literal {
    my $string = shift;
    node($string, undef);
}

sub union {
    my ($h, @s) = grep $_, @_;
    return unless $h;
    return $h unless @s;
    node(head($h), promise { union(@s, tail($h)); });
}

sub precat {
    my ($s, $c) = @_;
    transform { "$c$_[0]" } $s;
}

sub postcat {
    my ($s, $c) = @_;
    transform { "$_[0]$c" } $s;
}

sub concat {
    my ($S, $T) = @_;
    return unless $S && $T;
    my ($s, $t) = (head($S), head($T));

    node("$s$t", promise { union(postcat(tail($S), $t),
                                 precat(tail($T), $s),
                                 concat(tail($S), tail($T)))});
}
