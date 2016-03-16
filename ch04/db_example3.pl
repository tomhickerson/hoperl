#!/usr/bin/perl

# testing out the bug fix in FlatDB, should print two records apiece

use FlatDB;
use Iterator_Utils;

my $dbh = FlatDB->new('db.txt') or die $!;

my $q1 = $dbh->query("STATE", 'TX');
my $q2 = $dbh->query('STATE', 'NY');

for (1..2) {
    print Iterator_Utils::NEXTVAL($q1) . "\n";
    print Iterator_Utils::NEXTVAL($q2) . "\n";
}
