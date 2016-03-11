#!/usr/bin/perl

# permute 1 from page 129 of chapter 4 of HOP,
# originally from T. Christiansen and N. Torkington
# a pure recusive permutation formula, which would have lots of
# overhead if the list were to get long...

use Data::Dumper;

sub permute {
    my @items = @{ $_[0] };
    my @perms = @{ $_[1] };
    unless (@items) {
        print Dumper(@perms) . "\n";
    } else {
        my (@newitems, @newperms, $i);
        foreach $i (0..$#items) {
            @newitems = @items;
            @newperms = @perms;
            unshift(@newperms, splice(@newitems, $i, 1));
            permute([@newitems], [@newperms]);
        }
    }
}

#sample call
permute([qw(red yellow green)], []);
