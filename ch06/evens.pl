#!/usr/bin/perl

use Stream 'upfrom', 'show', 'transform';

my $evens = transform { $_[0] * 2} upfrom(1);
show($evens, 10);
