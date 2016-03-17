#!/usr/bin/perl

# flat db::iterator, example of a module that takes an interator in the place of a file handle from chapter 04 of HOP

package FlatDB_Iterator;
my $FIELDSEP = qr/\s+/;

sub new {
    my $class = shift;
    my $it = shift;
    my @field = @_;
    my %fieldnum = map { uc $field[$_] => $_ } (0..$#field);
    bless { FH => $it, FIELDS => \@field, FIELDNUM => \%fieldnum, FIELDSEP => $FIELDSEP } => $class;
}

# usage $dbh->query(fieldname, value)
use Iterator_Utils;
sub query {
    my $self = shift;
    my ($field, $value) = @_;
    my $fieldnum = $self->{FIELDNUM}{uc $field};
    return unless defined $fieldnum;
    my $it = $self->{FH};
    return Iterator_Utils::Iterator {
        local $_;
        while (defined ($_ = Iterator_Utils::NEXTVAL($it))) {
            my @fields = split $self->{FIELDSEP}, $_, -1;
            my $fieldval = $fields[$fieldnum];
            return $_ if $fieldval eq $value;
        }
        return;
    };
}

sub callbackquery {
    my $self = shift;
    my $is_interesting = shift;
    my $it = $self->{FH};
    return Iterator_Utils::Iterator {
        local $_;
        while (defined ($_ = Iterator_Utils::NEXTVAL($it))) {
            my %F;
            my @fieldnames = @{$self->{FIELDS}};
            my @fields = split $self->{FIELDSEP};
            for (0..$#fieldnames) {
                $F{$fieldnames[$_]} = $fields[$_];
            }
            return $_ if $is_interesting->(%F);
        }
        return;
    };
}

1;
