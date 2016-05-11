#!/usr/bin/perl

# starting with the flatDB packages and creation of a new DB for querying, etc
package FlatDB_Compose;

use base 'FlatDB';
use base 'Exporter';
@EXPORT_OK = qw(query_or query_and query_not query_without);
use Iterator_Logic;

# usage: $dbh->query(fieldname, value);
# returns all records for which fieldname == value
sub query {
    my $self = shift;
    my ($field, $value) = @_;
    my $fieldnum = $self->{FIELDNUM}{uc $field};
    return unless defined $fieldnum;
    my $fh = $self->{FH};
    seek $fh, 0, 0;
    <$fh>; # discard header line
    my $position = tell $fh;
    my $recno = 0;

    return sub {
        local $_;
        seek $fh, $position, 0;
        while (<$fh>) {
            chomp;
            $recno++;
            $position = tell $fh;
            my @fields = split $self->{FIELDSEP};
            my $fieldval = $fields[$fieldnum];
            return [$recno, @fields] if $fieldval eq $value;
        }
        return;
    };
}
