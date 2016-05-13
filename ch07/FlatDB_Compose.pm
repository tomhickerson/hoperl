#!/usr/bin/perl

# starting with the flatDB packages and creation of a new DB for querying, etc
package FlatDB_Compose;

use base 'FlatDB';
use base 'Exporter';
@EXPORT_OK = qw(query_or query_and query_not query_without);
use Iterator_Logic;

BEGIN {
    *query_or = i_or(sub { $_[0][0] <=> $_[1][0]});
    *query_and = i_and(sub { $_[0][0] <=> $_[1][0]});
    *query_without = i_without(sub { my ($a, $b) = @_; $a->[0] <=> $b->[0]});
}

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

sub callbackquery {
    my $self = shift;
    my $is_interesting = shift;
    my $fh = $self->{FH};
    seek $fh, 0, SEEK_SET;
    <$fh>;
    my $position = tell $fh;
    my $recno = 0;
    return sub {
        local $_;
        seek $fh, $position, SEEK_SET;
        while (<$fh>) {
            $position = tell $fh;
            chomp;
            $recno++;
            my %F;
            my @fieldnames = @{$self->{FIELDS}};
            my @fields = split $self->{FIELDSEP};
            for (0..$#fieldnames) {
                $F{$fieldnames[$_]} = $fields[$_];
            }
            return [$recno, @fields] if $is_interesting->(%F);
        }
        return;
    };
}

sub query_not {
    my $self = shift;
    my $q = shift;
    query_without($self->all, $q);
}

sub all {
    $_[0]->callbackquery( sub { 1 });
}

1;
