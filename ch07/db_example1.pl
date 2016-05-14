#!/usr/bin/perl

# first test of FlatDB_Compose

use FlatDB_Compose;
use Iterator_Utils 'NEXTVAL';

my $dbh = FlatDB->new('db.txt') or die $!;

my $q1 = $dbh->query("STATE", 'TX');
my $q2 = $dbh->query('STATE', 'NY');

for (1..2) {
    print NEXTVAL($q1) . "\n";
    print NEXTVAL($q2) . "\n";
}
