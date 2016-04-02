#!/usr/bin/perl

# powerset_recurse, brought to you by chapter 05 of HOP and Mastering Algorithms with Perl, pp 238-239
use Data::Dumper;

sub powerset_recurse ($) {
    my ($set) = @_;
    my $null = { };
    my $powerset = { $null, $null };
    while (my ($key, $value) = each %$set) {
        my @newitems;
        while (my ($powerkey, $powervalue) = each %$powerset) {
            my %subset = ();
            # copy the old set to the subset
            @subset{keys %{ $powerset->{$powerkey}}} = values %{ $powerset->{$powervalue}};
            $subset{$key} = $value;
            push @newitems, \%subset;
        }
        $powerset->{ $_ } = $_ for @newitems;
        print Dumper $powerset;
    }
    return $powerset;
}

my %set = (apple => "red", banana => "yellow", grape => "purple");

my %otherset = powerset_recurse(\%set);
# my %otherotherset = keys %otherset;
# my @otherotherotherset = keys %otherotherset;
# print "Generates @otherotherotherset sets\n";
print Dumper \%otherset;
