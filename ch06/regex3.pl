#!/usr/bin/perl

# next adaption of the regex package from chapter 06 of HOP, p. 281
use Regex qw(show2 union plus concat star literal);
use Stream qw(cutsort cut_bylen);

my $regex = concat(literal("a"), star(literal("b")));

show2($regex, 10);

# /^(aa|b)*$/
my $regex2 = star(union(literal("aa"), literal("b")));

show2($regex2, 10);

# /^(ab+|c)*$/
my $regex3 = star(union(concat(literal("a"), plus(literal("b"))), literal("c")
                  ));

show2($regex3, 30);

my $sorted = cutsort($regex3, sub { $_[0] cmp $_[1] }, \&cut_bylen);

show2($sorted, 30);
