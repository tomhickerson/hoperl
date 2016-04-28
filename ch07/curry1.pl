#!/usr/bin/perl

# providing examples of scale and currying from chapter 07 of HOP
use Stream 'transform', 'show', 'upfrom';

sub scale {
    my $c = shift;
    return sub {
        my $s = shift;
        transform { $_[0] * $c } $s;
    }
}

my $s = upfrom(3);
*double = scale(2);
*triple = scale(3);
my $s2;
$s2 = double($s);
my $s3;
$s3 = triple($s);
show($s2, 10);
print "\n";
show($s3, 10);
