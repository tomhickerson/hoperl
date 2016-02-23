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
    return unless defined $share_1;
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

my $share = find_share(5, [1,2,4,8]);
for my $treasure (@$share) {
    print $treasure . "\n";
}
