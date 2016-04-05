#!/usr/bin/perl

use Stream 'node', 'show', 'promise', 'transform';
# powers_of_2, from page 265 of HOP chapter 06

my $powers_of_2;
# we can call the warn below to show us the problems with tail() which we will then fix

$powers_of_2 = node(1, promise { transform {
                                 warn "Doubling $_[0]\n";
                                 $_[0] * 2 } $powers_of_2 });

show($powers_of_2, 10);
