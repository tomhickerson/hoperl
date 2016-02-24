#!/usr/bin/perl

# second version of find_share, with the partition subroutine, from pages 56-57 of HOP

sub find_share {
    my ($target, $treasures) = @_;
    return [] if $target == 0;
    return if $target < 0 || @$treasures == 0;
    my ($first, @rest) = @$treasures;
    my $solution = find_share($target - $first, \@rest);
    return [$first, @$solution] if $solution;
    return find_share($target, \@rest);
}

sub partition {
    my $total = 0;
    my $share_2;
    for my $treasure(@_) {
        $total += $treasure;
    }
    my $share_1 = find_share($total/2, [@_]);
    #print "Looking for this total in find_share: " . $total . "\n";
    return unless defined $share_1;
    #print "y";
    # some extra debugging above, to see if we made it to this point
    # it turns out that floats i.e. 7.5, will not return an answer
    my %in_share_1;
    for my $treasure(@$share_1) {
        ++$in_share_1{$treasure};
    }
    for my $treasure(@_) {
        if ($in_share_1{$treasure}) {
            --$in_share_1{$treasure};
        } else {
            push @$share_2, $treasure;
        }
    }
    return ($share_1, $share_2);

}

my $share_1 = find_share(7,[1,2,4,7]);
for my $treasure (@$share_1) {
    print $treasure . "\n";
}

print "\nUsing partition, the list contains: ";

my ($share_2, $share_3) = partition(1,2,4,7);
for my $t (@$share_2) {
    print $t . " ";
}

print "\nAnd the list does not contain: ";

for my $x (@$share_3) {
    print $x . " ";
}

print "\n";
