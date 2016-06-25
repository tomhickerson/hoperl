#!/usr/bin/perl

use Parser ':all';
use Lexer ':all';
# slightly modified version of the calculator, as we want to get input not from a file just yet

# my $input = allinput(\*STDIN);

my @input = q[a=12345679 * 6; b= a * 9; c=0 print b; c=4 ** 2; print c;];
my $input = sub { return shift @input };

my $lexer = iterator_to_stream(
               make_lexer($input,
                       ['TERMINATOR', qr/;\n*|\n+/                 ],
                       ['INT',        qr/\d+/                      ],
                       ['PRINT',      qr/\bprint\b/                ],
                       ['IDENTIFIER', qr|[A-Za-z_]\w*|             ],
                       ['OP',         qr#\*\*|[-=+*/()]#           ],
                       ['WHITESPACE', qr/\s+/,          sub { "" } ],
               )
             );

# print "do we get this far?";
## Chapter 8 section 4.6

my %VAR;

my ($base, $expression, $factor, $program, $statement, $term);
$Base       = parser { $base->(@_) };
$Expression = parser { $expression->(@_) };
$Factor     = parser { $factor->(@_) };
$Program    = parser { $program->(@_) };
$Statement  = parser { $statement->(@_) };
$Term       = parser { $term->(@_) };

# modifying all the following for overloading in section 8.9

$program = star($Statement) - \&End_of_Input;

$statement = L("PRINT") - $Expression - L('TERMINATOR')
                       >>  sub { print ">> $_[1]\n" }
                       | L('IDENTIFIER') - L('OP', '=') - $Expression - L('TERMINATOR')
                       >> sub { $VAR{$_[0]} = $_[2] };

$expression = $Term - star(L('OP', '+') - $Term
                           >> sub { my $term = $_[1]; sub { $_[0] + $term } }
                           |
                           L('OP', '-') - $Term
                           >> sub { my $term = $_[1]; sub { $_[0] - $term } }
                           )
    >> sub { my($first, $rest) = @_; for my $f (@$rest) { $first = $f->($first); } $first; };

$term = $Factor - star(L('OP', '*') - $Factor
                       >> sub { my $factor = $_[1];
                                sub { $_[0] * $factor } }
                       |
                       L('OP', '/') - $Factor
                       >> sub { my $factor = $_[1];
                                sub {$_[0] / $factor }} )
    >> sub { my($first, $rest) = @_; for my $f (@$rest) { $first = $f->($first); } $first; };

$factor = $Base - (L('OP', '**') - $Factor >> sub { $_[1] }
    |
    $Parser::nothing >> sub { 1 }
    )
    >> sub { $_[0] ** $_[1] };

$base      = L('INT') | lookfor('IDENTIFIER',
                                sub { $VAR{$_[0][1]}})
    | L('OP', '(') - $Expression - L('OP', ')')
                         >> sub { $_[1] }
                      ;
$program->($lexer);
