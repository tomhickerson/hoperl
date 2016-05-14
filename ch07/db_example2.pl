#!/usr/bin/perl

# first test of FlatDB_Compose

use FlatDB_Compose 'query_or', 'query_and';
use Iterator_Utils 'NEXTVAL';
use Data::Dumper;

my $dbh = FlatDB_Compose->new('db.txt') or die $!;

my ($ny, $debtor, $ma) = ($dbh->query('STATE', 'NY'),
    $dbh->callbackquery(sub {my %F = @_; $F{OWES} > 100}),
                          $dbh->query('STATE', 'MA'));

my $q1 = query_or($ny, query_and($debtor, $ma));

while (defined(my $q2 = NEXTVAL($q1))) {
    print Dumper($q2) . "\n";
}
