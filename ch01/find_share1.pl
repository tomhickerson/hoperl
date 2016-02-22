#!/usr/bin/perl

# simple version of find_share, described on page 53-55 of HOP
# more complex version in the next file and in chapter 3

sub find_share {
    my ($target, $treasures) = @_;
    return [] if $target == 0;
    return if $target < 0 || @$treasures == 0;
    my ($first, @rest) = @$treasures;
    my $solution = find_share($target - $first, \@rest);
    return [$first, @$solution] if $solution;
    return find_share($target, \@rest);
}

my $share = find_share(5, [1,2,4,8]);
for my $treasure (@$share) {
    print $treasure . "\n";
}
