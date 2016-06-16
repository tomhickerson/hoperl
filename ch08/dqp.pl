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
