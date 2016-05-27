#!/usr/bin/perl

# second example from chapter 08 about lexers and parsers
# trying to group the multiplication signed numbers together

use Parser ':all';
use Lexer ':all';

my ($expression, $term, $factor);

my $Expression = parser { $expression->(@_) };
my $Term = parser { $term->(@_) };
my $Factor = parser { $factor->(@_) };

$expression = alternate(concatenate($Term, lookfor(['OP', '+']), $Expression), $Term);

$term = alternate(concatenate($Factor, lookfor(['OP', '*']), $Term), $Factor);

$factor = alternate(lookfor('INT'), concatenate(lookfor(['OP', '(']), $Expression, lookfor(['OP', ')'])));

my $entire_input = concatenate($Expression, \&End_of_Input);

my @input = q[2 * 3 + 5];

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
