#!/usr/bin/perl

# third example from chapter 08 about lexers and parsers
# trying to group the multiplication signed numbers together
# adding the transform function T
# now, instead of just grouping, we are going to calculate the numbers using transform
# now, removing the expression tail and adding the new 'star' code from a previous commit
# also including division here

use Parser ':all';
use Lexer ':all';

my ($expression, $term, $factor);

my $Expression = parser { $expression->(@_) };
my $Term = parser { $term->(@_) };
my $Factor = parser { $factor->(@_) };

$expression = T(concatenate($Term, star(alternate(T(concatenate(lookfor(['OP', '+']),
                                                    $Term),
                                                  sub { my $term_value = $_[1];
                                                    sub { $_[0] + $term_value };
                                                    }),
                                        T(concatenate(lookfor(['OP', '-']), $Term),
                                                  sub { my $term_value = $_[1];
                                          sub { $_[0] - $term_value };
                                          }),
                                        ))),
                sub { my ($total, $funcs) = @_;
                      for my $f (@$funcs) {
                          $total = $f->($total);
                      }
                      $total;
                });

$term = T(concatenate($Factor, star(alternate(T(concatenate(lookfor(['OP', '*']),
                                                    $Term),
                                                  sub { my $term_value = $_[1];
                                                    sub { $_[0] * $term_value };
                                                    }),
                                        T(concatenate(lookfor(['OP', '/']), $Term),
                                                  sub { my $term_value = $_[1];
                                          sub { $_[0] / $term_value };
                                          }),
                                        ))),
                sub { my ($total, $funcs) = @_;
                      for my $f (@$funcs) {
                          $total = $f->($total);
                      }
                      $total;
                });

$factor = alternate(lookfor('INT'), T(concatenate(lookfor(['OP', '(']), $Expression, lookfor(['OP', ')'])), sub { $_[1] }));

my $entire_input = T(concatenate($Expression, \&End_of_Input), sub { $_[0] });

my @input = q[(4 + 3 - 5) / 2];
# will now return 1, since we are looking in the 'correct' direction
# note that without parens, the / would work first and the result would be 4.5

my $input = sub { return shift @input };

my $lexer = iterator_to_stream(
    make_lexer($input,
    ['TERMINATOR', qr/;\n*|\n+/],
    ['INT', qr/\b\d+\b/],
    ['PRINT', qr/\bprint\b/],
    ['IDENTIFIER', qr|[A-Za-z_]\w*|],
    ['OP', qr#\*\*|[-=+*/()]#],
               ['WHITESPACE', qr/\s+/, sub { "" }]));

if (my($result, $remaining_input) = $entire_input->($lexer)) {
    use Data::Dumper;
    print Dumper($result) . "\n";
} else {
    print "Parse Error!\n" . $result . "\n" . $remaining_input . "\n";
}
