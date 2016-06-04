#!/usr/bin/perl

use Parser ':all';
use Lexer ':all';
# slightly modified version of the calculator, as we want to get input not from a file just yet

# my $input = allinput(\*STDIN);
my @input = q[a=12345679 * 6; b= a * 9; c=0; print b; c=4 ** 2; print c;];
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

$program = concatenate(star($Statement), \&End_of_Input);

$statement = alternate(T(concatenate(lookfor('PRINT'),
                                     $Expression,
                                     lookfor('TERMINATOR')),
                         sub { print ">> $_[1]\n" }),
                       T(concatenate(lookfor('IDENTIFIER'),
                                     lookfor(['OP', '=']),
                                     $Expression,
                                     lookfor('TERMINATOR')
                                    ),
                         sub { $VAR{$_[0]} = $_[2] }),
                      );

$expression = operator($Term,   [lookfor(['OP', '+']), sub { $_[0] + $_[1] }],
                  [lookfor(['OP', '-']), sub { $_[0] - $_[1] }]);

$term = operator($Factor, [lookfor(['OP', '*']), sub { $_[0] * $_[1] }],
                  [lookfor(['OP', '/']), sub { $_[0] / $_[1] }]);

$factor = T(concatenate($Base,
                        alternate(T(concatenate(lookfor(['OP', '**']),
                                                $Factor),
                                    sub { $_[1] }),
                                  T(\&nothing, sub { 1 }))),
            sub { $_[0] ** $_[1] });

$base      = alternate(lookfor('INT'),
                       lookfor('IDENTIFIER',
                                sub { $VAR{$_[0][1]} || 0 }),
                       T(concatenate(lookfor(['OP', '(']),
                                     $Expression,
                                     lookfor(['OP', ')'])),
                         sub { $_[1] })
                      );
$program->($lexer);
