#!/usr/bin/perl

# third example from chapter 08 about lexers and parsers
# trying to group the multiplication signed numbers together
# adding the transform function T
# now, instead of just grouping, we are going to calculate the numbers using transform

use Parser ':all';
use Lexer ':all';

my ($expression, $term, $factor);

my $Expression = parser { $expression->(@_) };
my $Term = parser { $term->(@_) };
my $Factor = parser { $factor->(@_) };

$expression = alternate(T(concatenate($Term, lookfor(['OP', '+']), $Expression), sub { $_[0] + $_[2]}), $Term);

$term = alternate(T(concatenate($Factor, lookfor(['OP', '*']), $Term), sub { [$_[0] * $_[2]] }), $Factor);

$factor = alternate(lookfor('INT'), T(concatenate(lookfor(['OP', '(']), $Expression, lookfor(['OP', ')'])), sub { $_[1] }));

my $entire_input = T(concatenate($Expression, \&End_of_Input), sub { $_[0] });

my @input = q[2 * (3 + 4)];
# will now return 14

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
