#!/usr/bin/perl

# Iterator Logic, a package from chapter 07 of HOP
package Iterator_Logic;
use base 'Exporter';
@EXPORT = qw(i_or_ i_or i_and_ i_and i_without_ i_without);

sub i_or_ {
    my ($cmp, $a, $b) = @_;
    my ($av, $bv) = ($a->(), $b->());
    return sub {
        my $rv;
        if (!defined $av && !defined $rv) {
            return;
        } elsif (!defined $av) {
            $rv = $bv;
            $bv = $b->();
        } elsif (!defined $bv) {
            $rv = $av;
            $av = $a->();
        } else {
            my $d = $cmp->($av, $bv);
            if ($d < 0) { $rv = $av; $av = $a->() }
            elsif ($d > 0) { $rv = $bv; $bv = $b->() }
            else { $rv = $av; $av = $a->(); $bv = $b->() }
        }
        return $rv;
    };
}

sub i_and_ {
    my ($cmp, $a, $b) = @_;
    my ($av, $bv) = ($a->(), $b->());
    return sub {
        my $d;
        until (! defined $av || ! defined $bv || ($d = $cmp->($av, $bv)) == 0) {
            if ($d < 0) { $av = $a->() }
            else { $bv = $b->() }
        }
        return unless defined $av && defined $bv;
        my $rv = $av;
        ($av, $bv) = ($a->(), $b->());
        return $rv;
    }
}

# $a but not $b
sub i_without_ {
    my ($cmp, $a, $b) = @_;
    my ($av, $bv) = ($a->(), $b->());
    return sub {
        while (defined $av) {
            my $d;
            while (defined $bv && ($d = $cmp->($av, $bv)) > 0) {
                $bv = $b->();
            }
            if (!defined $bv || $d < 0) {
                my $rv = $av; $av = $a->(); return $rv;
            } else {
                $bv = $b->();
                $av = $a->();
            }
        }
        return;
    }
}

use Curry;
BEGIN { *i_or = curry(\&i_or_);
        *i_and = curry(\&i_and_);
        *i_without = curry(\&i_without_);
}
