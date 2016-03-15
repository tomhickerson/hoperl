#!/usr/bin/perl

use Iterator_Utils;

sub make_genes {
    my $pat = shift;
    my @tokens = split /[()]/, $pat;
    for (my $i = 1; $i < @tokens; $i += 2) {
        $tokens[$i] = [0, split(//, $tokens[$i])];
    }
    my $FINISHED = 0;
    return Iterator_Utils::Iterator {
        return if $FINISHED;
        my $finished_incrementing = 0;
        my $result = "";
        for my $token (@tokens) {
            if (ref $token eq "") { #plain string
                $result .= $token;
            } else { # its a wildcard
                my ($n, @c) = @$token;
                $result .= $c[$n];
                unless ($finished_incrementing) {
                    if ($n == $#c) {
                        $token->[0] = 0;
                    } else {
                        $token->[0]++;
                        $finished_incrementing = 1;
                    }
                }
            }
        }
        $FINISHED = 1 unless $finished_incrementing;
        return $result;
    };
}

my $it = make_genes('(abcdef)(gh)-(12)');
print "$s\n" while $s = Iterator_Utils::NEXTVAL($it);
