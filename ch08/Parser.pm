#!/usr/bin/perl

# creating the Parser from chapter 08, HOP

package Parser;
use Stream ':all';
use base Exporter;
@EXPORT_OK = qw(parser nothing End_of_Input lookfor alternate concatenate star list_of operator T error action test);
%EXPORT_TAGS = ('all' => \@EXPORT_OK);

sub parser (&);

sub nothing {
    my $input = shift;
    return (undef, $input);
}

sub End_of_Input {
    my $input = shift;
    defined($input) ? () : (undef, undef);
}
