#!/usr/bin/perl

use FlatDB;
use Iterator_Utils;

my $dbh = FlatDB->new('db.txt') or die $!;
my $q = $dbh->query('STATE', 'TX');
while (my $rec = Iterator_Utils::NEXTVAL($q)) {
    print $rec . "\n";
}
