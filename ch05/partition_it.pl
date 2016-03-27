#!/usr/bin/perl

use Data::Dumper;

# the make-partition code, from chapter 5 of HOP, page 210

sub make_partitioner {
    my ($n, $treasures) = @_;
    print "@_\n";
    my @todo = [$n, $treasures, []];
    sub {
        while (@todo) {
            print "@todo\n";
            my $cur = pop @todo;
            my ($target, $pool, $share) = @$cur;
            print "$target \n";
            if ($target == 0) { return $share; }
            next if $target < 0 || @$pool == 0;

            my ($first, @rest) = @$pool;

            push @todo, [$target, \@rest, $share] if @rest;
            if ($target == $first) {
                return [@$share, $first];
            } elsif ($target > $first && @rest) {
                push @todo, [$target-$first, \@rest, [@$share, $first]];
            }
        }
        return undef;
    } # end of anonymous function
} # end of make_partitioner

my (@result, $share) = make_partitioner(4, [1,2,3,4]);
print "$share\n";
print Dumper(@result);
