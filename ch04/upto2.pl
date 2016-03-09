#!/usr/bin/perl

# upto, an example of iteration using syntactic sugar from the module

use Iterator_Utils;

sub upto {
    my ($m, $n) = @_;
    return Iterator_Utils::Iterator { return $m <= $n ? $m++ : undef; };
}

my $it = upto(3,9);

while (defined(my $value = Iterator_Utils::NEXTVAL($it))) {
    print "$value\n";
}
