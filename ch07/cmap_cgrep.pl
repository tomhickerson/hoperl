#!/usr/bin/perl

# options of map and grep using currying from chapter 07 of HOP
use Data::Dumper;

sub cmap(&) {
    my $f = shift;
    my $r = sub {
        my @result;
        for (@_) {
            push @result, $f->($_);
        }
        @result;
    };
    return $r;
}

sub cgrep(&) {
    my $f = shift;
    my $r = sub {
        my @result;
        for (@_) {
            push @result, $_ if $f->($_);
        }
        @result;
    };
    return $r;
}

my $double = cmap { $_ * 2 };
my $triple = cmap { $_ * 3 };

print Dumper($double->(1..5));
print Dumper($triple->(1..5));
