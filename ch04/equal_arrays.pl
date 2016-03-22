#!/usr/bin/perl

# equal arrays, where we try to look at two arrays and make sure they are equal, from p 178 of HOP chapter 4

use Iterator_Utils;

sub equal_arrays (\@\@) {
    my ($x, $y) = @_;
    return unless @$x == @$y;
    my $xy = each_array(@_);
    while (my ($xe, $ye) = Iterator_Utils::NEXTVAL($xy)) {
        return unless $xe eq $ye;
    }
    return 1;
}

sub each_array {
    my @arrays = @_;
    my $cur_elt = 0;
    my $max_size = 0;
    for (@arrays) {
        $max_size = @$_ if @$_ > $max_size;
    }

    return Iterator_Utils::Iterator {
        $cur_elt = 0, return () if $cur_elt >= $max_size;
        my $i = $cur_elt++;
        return map $_->[$i], @arrays;
    };
}

my @x = (1, 2, 3, 4, 5, 6, 7, 8);
my @y = ('Alaska', 'Idaho', 'Hawaii', 'New Zealand');
if (equal_arrays(@y, @y)) {
    print "Arrays Equal\n";
}
if (equal_arrays(@x, @y)) {
    print "Arrays Equal\n";
} else {
    print "Arrays not so Equal\n";
}
