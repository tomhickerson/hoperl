#!/usr/bin/perl

# another test of FlatDB_0v1 and operator overloading, this time using without (-)

use FlatDB_0v1;
use Iterator_Utils 'NEXTVAL';
use Data::Dumper;

my $dbh = FlatDB_0v1->new('db.txt') or die $!;

my ($tx, $debtor, $ma) = ($dbh->query('STATE', 'TX'),
    $dbh->callbackquery(sub {my %F = @_; $F{OWES} > 100}),
                          $dbh->query('STATE', 'MA'));

my $q1 = $debtor & $tx - $ma;

while (defined(my $q2 = NEXTVAL($q1))) {
    print Dumper($q2) . "\n";
}

# queries are not reusable - need to refresh the queries in order to run them again

$debtor = $dbh->callbackquery(sub {my %F = @_; $F{OWES} > 100});
$ma = $dbh->query('STATE', 'MA');

my $q3 = $debtor | $ma;

while (defined(my $q4 = NEXTVAL($q3))) {
    print Dumper($q4) . "\n";
}
