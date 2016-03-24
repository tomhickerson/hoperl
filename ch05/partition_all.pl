#!/usr/bin/perl

use Data::Dumper;

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
