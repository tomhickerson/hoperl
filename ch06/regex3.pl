#!/usr/bin/perl

# next adaption of the regex package from chapter 06 of HOP, p. 281
use Regex qw(show2 union plus concat star literal);

my $regex = concat(literal("a"), star(literal("b")));

show2($regex, 10);

# /^(aa|b)*$/
my $regex2 = star(union(literal("aa"), literal("b")));

show2($regex2, 16);

# /^(ab+|c)*$/
my $regex3 = star(union(concat(literal("a"), plus(literal("b"))), literal("c")
                  ));

show2($regex3, 20);
