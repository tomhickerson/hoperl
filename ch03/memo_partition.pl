#!/usr/bin/perl

use Time::HiRes qw(time);
use Data::Dumper;
# manual memoized version of partitioning from chapter 3 of HOP
#
# modifying memoize to accept different keygen functions for memoize, may use a simpler one than memo3, but we'll see

sub memoize {
    my ($func, $keygen) = @_;
    my $keyfunc;
    if ($keygen eq '') {
        $keygen = q{ join ',', @_};
    } elsif (UNIVERSAL::isa($keygen, 'CODE')) {
        $keyfunc = $keygen;
        $keygen = q{$keyfunc->(@_)};
    }
    my %cache;
    my $newcode = q{
        sub {
            my $key = do { KEYGEN };
            $cache{$key} = $func->(@_) unless exists $cache{$key};
            return $cache{$key};
        }
    };
    $newcode =~ s/KEYGEN/$keygen/g;
    return eval $newcode;
}

sub partition {
    my ($target, $treasures) = @_;
    return [] if $target == 0;
    return  if $target < 0 || @$treasures == 0;
    my ($first, @rest) = @$treasures;
    my $solution = partition($target - $first, \@rest);
    return [$first, @$solution] if $solution;
    return partition($target, \@rest);
}

*partition = memoize(\&partition, sub {join "-", @{$_[1]}, @{$_[0]}});

my $start = time();
# much like the code in chapter one, we get a list back with all the elements that can fit in the first variable
my ($target, @rest) = *partition->(7, [1,2,4,7]);
print Dumper($target) . "\n";
print Dumper(@rest) . "\n";

my ($target2, @rest2) = *partition->(200, [1..7]);
print Dumper($target2) . "\n";
print Dumper(@rest2) . "\n";

my $end = time();
printf("%.5f\n", $end - $start );
