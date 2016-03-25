#!/usr/bin/perl

use Data::Dumper;

# initial stab at the code examples from chapter 5 of HOP.
# note that this dies upon execution, will continue to look at that

sub partition {
    my ($target, $treasures) = @_;
    return [] if $target == 0;
    return () if $target < 0 || $treasures == 0;
    my ($first, @rest) = @$treasures;
    my @solutions = partition($target - $first, @rest);
    return ((map {[$first, @$_]} @solutions), partition($target, \@rest));
}

my @answer = partition(5, [1, 2, 3, 4]);
print Dumper(@answer);
