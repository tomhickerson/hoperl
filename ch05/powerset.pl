#!/usr/bin/perl

# powerset_recurse, brought to you by chapter 05 of HOP and Mastering Algorithms with Perl
use Data::Dumper;

# needs to be prototyped ahead of itself, since it's recursive
sub powerset_recurse ($;@);

sub powerset_recurse ($;@) {
    my ($set, $powerset, $keys, $values, $nmembers, $i) = @_;

    if (@_ == 1) {
        # initialise
        my $null = { };
        $powerset = { $null, $null };
        $keys = [ keys %{ $set } ];
        $values = [ values %{ $set } ];
        $nmembers = keys %{ $set }; # this many numbers
        $i = 0; # the current round
    }
    return $powerset if $i == $nmembers;
    # remapping
    my @powerkeys = keys %{ $powerset };
    my @powervalues = values %{ $powerset };
    my $powern = @powerkeys;
    my $j;

    for ($j = 0; $j < $powern; $j++) {
        my %subset = ( );
        # copy the old set to the subset
        @subset{keys %{ $powerset->{$powerkeys[$j]}}} = values %{ $powerset->{$powervalues[$j]}};
        $subset{$keys->[$i]} = $values->[$i];
        $powerset->{ \%subset } = \%subset;
    }
    # and recurse
    powerset_recurse($set, $powerset, $keys, $values, $nmembers, $i+1);
}

my %set = {apple => 'red', banana => 'yellow', grape => 'purple'};

my %otherset = powerset_recurse(%set);
# my %otherotherset = keys %otherset;
# my @otherotherotherset = keys %otherotherset;
# print "Generates @otherotherotherset sets\n";
print Dumper \%otherset;
