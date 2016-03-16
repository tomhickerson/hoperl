#!/usr/bin/perl

use FlatDB;
use Iterator_Utils;

my $dbh = FlatDB->new('db.txt') or die $!;
my $q = $dbh->callbackquery(sub {my %F=@_; $F{OWES} > 10 });
while (my $rec = Iterator_Utils::NEXTVAL($q)) {
    print $rec . "\n";
}
