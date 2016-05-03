#!/usr/bin/perl

# options of map and grep using currying from chapter 07 of HOP
use Data::Dumper;

sub cmap(&;@) {
    my $f = shift;
    my $r = sub {
        my @result;
        for (@_) {
            push @result, $f->($_);
        }
        @result;
    };
    return @_ ? $r->(@_) : $r;
}

sub cgrep(&;@) {
    my $f = shift;
    my $r = sub {
        my @result;
        for (@_) {
            push @result, $_ if $f->($_);
        }
        @result;
    };
    return @_ ? $r->(@_) : $r;
}

my @double = cmap { $_ * 2 } (1..5);
my @triple = cmap { $_ * 3 } (1..5);
my @quadruple = cgrep { $_ % 4 == 0} (1..20);

print Dumper(@double);
print Dumper(@triple);
print Dumper(@quadruple);
