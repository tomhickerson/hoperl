#!/usr/bin/perl

# powerset_recurse, brought to you by chapter 05 of HOP and Mastering Algorithms with Perl
use Data::Dumper;

sub powerset_recurse ($) {
    my ( $set ) = @_;
    my $null = { };
    my $powerset = { $null, $null };
    my $keys = [ keys %{ $set }];
    my $values = [ values %{ $set }];
    my $nmembers = keys %{ $set };
    my $i = 0;

    until ($i == $nmembers) {
        # remap here now
        my @powerkeys = keys %{ $powerset };
        my @powervalues = values %{ $powerset };
        my $powern = @powerkeys;
        my $j;

        for ($j = 0; $j < $powern; $j++) {
            my %subset = ( );
            @subset{keys %{ $powerset->{ $powerkeys[$j]}}} = values %{ $powerset->{ $powervalues[$j]}};
            # add the new member to the subset
            $subset{$keys->[$i]} = $values->[$i];
            # add the new subset to the powerset
            $powerset->{\%subset} = \%subset;
            print Dumper $powerset;
        }
        $i++;
    }
    return $powerset;

}

my %set = (apple => "red", banana => "yellow", grape => "purple");

my %otherset = powerset_recurse(\%set);
# my %otherotherset = keys %otherset;
# my @otherotherotherset = keys %otherotherset;
# print "Generates @otherotherotherset sets\n";
print Dumper \%otherset;
