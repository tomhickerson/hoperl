#!/usr/bin/perl

# upto, a simple example of an iteration from chapter 4 of HOP

sub upto {
    my ($m, $n) = @_;
    return sub { return $m <= $n ? $m++ : undef; };
}

my $it = upto(3,9);

while (defined(my $value = $it->())) {
    print "$value\n";
}
