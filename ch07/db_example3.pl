#!/usr/bin/perl

# test of FlatDB_0v1 and operator overloading
# note that we are doing the same work as db_example2, but instead we are using redefined operator symbols to query what we want
use FlatDB_0v1;
use Iterator_Utils 'NEXTVAL';
use Data::Dumper;

my $dbh = FlatDB_0v1->new('db.txt') or die $!;

my ($ny, $debtor, $ma) = ($dbh->query('STATE', 'NY'),
    $dbh->callbackquery(sub {my %F = @_; $F{OWES} > 100}),
                          $dbh->query('STATE', 'MA'));

my $q1 = $ny | $debtor & $ma;

while (defined(my $q2 = NEXTVAL($q1))) {
    print Dumper($q2) . "\n";
}
