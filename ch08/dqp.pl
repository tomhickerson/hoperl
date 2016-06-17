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

my $parser_dbh;
sub set_parser_dbh { $parser_dbh = shift }
sub parser_dbh { $parser_dbh }

my %string_version = ('>' => 'gt', '>=' => 'ge', '==' => 'eq', '<' => 'lt', '<=' => 'le', '!=' => 'ne');

$squery = alternate(T(concatenate(lookfor('LPAREN'), $CQuery, lookfor('RPAREN'),), sub { $_[1]}),
    T(concatenate(lookfor('FIELD'), lookfor('OP'), lookfor('NUMBER')),
      sub {
          my ($field, $op, $val) = @_;
          my $cmp_code = 'sub { $_[0] OP $_[1] }';
          $cmp_code =~ s/OP/$op/;
          my $cmp = eval($cmp_code) or die;
          my $cb = sub { my %F = @_; $cmp->($F{$field}, $val)};
          $parser_dbh->callbackquery($cb);
      }),
    T(concatenate(lookfor('FIELD'), lookfor('OP'), lookfor('STRING')),
                    sub {
                        if ($_[1] eq '==') {
                            $parser_dbh->query($_[0], $_[2]);
                        } else {
                            my ($field, $op, $val) = @_;
                            my $cmp_code = 'sub { $_[0] OP $_[1] }';
                            $cmp_code =~ s/OP/$string_version{$op}/;
                            my $cmp = eval($cmp_code) or die;
                            my $cb = sub { my %F = @_; $cmp->($F{$field}, $val)};
                            $parser_dbh->callbackquery($cb);
                        }
      }),
    );

sub parse_query {
    my $self = shift;
    my $query = shift;
    my $lexer = lex_input($query);
    my $old_parser_dbh = parser_dbh();
    set_parser_dbh($self);
    my ($result) = $cquery->($lexer);
    set_parser_dbh($old_parser_dbh);
    return $result;
}

use Data::Dumper;
my $first_query = "STATE = 'NY' | OWES > 100 & STATE = 'MA'";
print Dumper(parse_query($first_query));
