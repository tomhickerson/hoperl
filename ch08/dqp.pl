#!/usr/bin/perl

# dqp, a problem to parse SQL-like statements against a flat file DB
use Lexer ':all';

sub lex_input {
    my @input = @_;
    my $input = sub { shift @input };

    my $lexer = iterator_to_stream(make_lexer($input,
                                   ['STRING', qr/' (?: \\. | [^'])*' | " (?: \\. | [^"])*"/sx,
                                   sub {
                                       my $s = shift;
                                       $s =~ s/.//; $s =~ s/.$//;
                                       $s =~ s/\\(.)/$1/g;
                                       ['STRING', $s] }],
                                   ['FIELD', qr/[A-Z]+/ ],
                                   ['AND', qr/&/ ],
                                   ['OR', qr/\|/ ],
                                   ['OP', qr/[!<>=]=|[<>=]/,
                                    sub { $_[0] =~ s/^=$/==/;
                                          ['OP', $_[0]] } ],
                                   ['LPAREN', qr/[(]/],
                                   ['RPAREN', qr/[)]/],
                                   ['NUMBER', qr/\d+ (?:\.\d*)? | \.\d+/x ],
                                   ['SPACE', qr/\s+/, sub { "" }],
                                   )
        );
}

use Parser ':all';
use FlatDB_Compose qw(query_or query_and);
my ($cquery, $squery, $term);
my $CQuery = parser { $cquery->(@_) };
my $SQuery = parser { $squery->(@_) };
my $Term = parser { $term->(@_) };

use FlatDB;
$cquery = operator($Term, [lookfor('OR'), \&query_or] );
$term = operator($SQuery, [lookfor('AND'), \&query_and] );
