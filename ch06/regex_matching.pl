#!/usr/bin/perl

# matching examples from HOP chapter 06

use Regex qw(show2 charclass concat union);
use Stream qw(node promise transform drop);

sub matches {
    my ($string, $regex) = @_;
    while ($regex) {
        my $s = drop($regex);
        return 1 if $s eq $string;
        return 0 if length($s) > length($string);
    }
    return 0;
}

# make sure the contents are balanced
sub bal {
    my $contents = shift;
    my $bal;
    $bal = node("", promise { concat($bal, union($contents, transform {"($_[0])"} $bal,))});
}

my @str = ("aaaa", "bbbb", "cccc", "aabb");

foreach (@str) {
    if (matches($_, bal(charclass('ab')))) {
        print $_ . " fit the balance\n";
    } else {
        print $_ . " did NOT fit the balance\n";
    }
}
