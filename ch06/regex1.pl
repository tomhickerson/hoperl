#!/usr/bin/perl

# first try at using the Regex module

use Regex qw(concat union literal);
use Stream 'show';

my $z = concat(union(literal("a"), literal("b")),
               union(literal("c"), literal("d")));

show($z);
