#!/usr/bin/perl

use Iterator_Utils;
#use Iterator_Utils::Iterator;

sub permute {
    my @items = @_;
    my @pattern = (0) x @items;
    return Iterator_Utils::Iterator {
        return unless @pattern;
        my @result = pattern_to_permutation(\@pattern, \@items);
        @pattern = increment_pattern(@pattern);
        return @result;
    };
}

sub pattern_to_permutation {
    my $pattern = shift;
    my @items = @{shift()};
    my @r;
    for (@$pattern) {
        push @r, splice(@items, $_, 1);
    }
    @r;
}

# now the example from the book talks about the odometer by the time we get here, so I am modifying the variables a bit
sub increment_pattern {
    my @od = @_;
    my $wheel = $#od;
    until ($od[$wheel] < $#od-$wheel || $wheel < 0) {
        $od[$wheel] = 0;
        $wheel--; # next to the left
    }
    if ($wheel < 0) {
        return; # no more sequences, fell off the left end
    } else {
        $od[$wheel]++; # wheel turns one notch
        return @od;
    }
}


my $it = permute('A'..'D');
while (my @p = Iterator_Utils::NEXTVAL($it)) {
    print "@p\n";
}
