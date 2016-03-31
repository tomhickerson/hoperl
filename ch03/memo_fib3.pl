#!/usr/bin/perl

use Time::HiRes qw(time);
# manual memoized version of fibonacci from chapter 3 of HOP
#
# now, modifying memoize to accept different keygen functions for memoize

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

sub fib {
    my ($month) = @_;
    if ($month < 2) { $month }
    else { fib($month-1) + fib($month-2); }
}

*fib = memoize(\&fib, '');

my $fibr = $ARGV[0];
my $start = time();
print *fib->($fibr) . "\n";
my $end = time();
printf("%.5f\n", $end - $start );
