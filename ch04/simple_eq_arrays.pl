#!/usr/bin/perl

# the simple version of equal arrays, where we try to look at two arrays and make sure they are equal, from p 177 of HOP chapter 4

sub equal_arrays (\@\@) {
    my ($x, $y) = @_;
    return unless @$x == @$y;
    for my $i (0..$#$x) {
        return unless $x->[$i] eq $y->[$i];
    }
    return 1;
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
