#!/usr/bin/perl

# each like, a mapping function from pages 182-183 from HOP chapter 4

use Iterator_Utils;

sub eachlike (&$) {
    my ($transform, $it) = @_;
    return Iterator_Utils::Iterator {
        local $_ = Iterator_Utils::NEXTVAL($it);
        return unless defined $_;
        my $value = $transform->();
        return wantarray ? ($_, $value) : $value;
    };
}

sub upto {
    my ($m, $n) = @_;
    return Iterator_Utils::Iterator { return $m <= $n ? $m++ : undef; };
}

my $n = eachlike { $_ * 2 } upto(3,6);

while (defined(my $q = Iterator_Utils::NEXTVAL($n))) {
    print "$q\n";
}

my $n2 = eachlike { $_ * 2 } upto(3,6);

while (my @q = Iterator_Utils::NEXTVAL($n2)) {
    print "@q\n";
}
