#!/usr/bin/perl

use Iterator_Utils;
# permute again, but this time without so many functions - from pp 134-135 of HOP chapter 4

sub permute {
    my @items = @_;
    my $n = 0;
    return Iterator_Utils::Iterator {
        $n++, return @items if $n == 0;
        my $i;
        my $p = $n;
        for ($i = 1; $i <= @items && $p % $i == 0; $i++) {
            $p /= $i;
        }
        my $d = $p % $i;
        my $j = @items - $i;
        return if $j < 0;
        @items[$j + 1..$#items] = reverse @items[$j + 1..$#items];
        @items[$j, $j + $d] = @items[$j + $d, $j];
        $n++;
        return @items;
    };
}

my $it = permute('A'..'D');

while (my @p = Iterator_Utils::NEXTVAL($it)) {
    print "@p\n";
}
