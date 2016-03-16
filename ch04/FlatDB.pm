#!/usr/bin/perl

# flat db, first example of a module for file access from chapter 04 of HOP
package FlatDB;
my $FIELDSEP = qr/:/;

sub new {
    my $class = shift;
    my $file = shift;
    open my $fh, "<", $file or return;
    chomp(my $schema = <$fh>);
    my @field = split $FIELDSEP, $schema;
    my %fieldnum = map { uc $field[$_] => $_ } (0..$#field);
    bless { FH => $fh, FIELDS => \@field, FIELDNUM => \%fieldnum, FIELDSEP => $FIELDSEP } => $class;
}

#usage $dbh->query(fieldname, value)
use Fcntl ':seek';
use Iterator_Utils;
sub query {
    my $self = shift;
    my ($field, $value) = @_;
    my $fieldnum = $self->{FIELDNUM}{uc $field};
    return unless defined $fieldnum;
    my $fh = $self->{FH};
    seek $fh, 0, SEEK_SET;
    <$fh>;
    return Iterator_Utils::Iterator {
        local $_;
        while (<$fh>) {
            chomp;
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
    my $fh = $self->{FH};
    seek $fh, 0, SEEK_SET;
    <$fh>;
    return Iterator_Utils::Iterator {
        local $_;
        while (<$fh>) {
            chomp;
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
