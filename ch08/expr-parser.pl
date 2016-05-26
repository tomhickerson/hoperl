#!/usr/bin/perl

use Parser ':all';
use Lexer ':all';

my $expression;

my $Expression = parser { $expression->(@_) };

$expression = alternate(
    concatenate(lookfor('INT'),
                lookfor(['OP', '+']),
                $Expression),
    concatenate(lookfor('INT'),
                lookfor(['OP', '*']),
                $Expression),
    concatenate(lookfor(['OP', '(']),
                $Expression,
                lookfor(['OP', ')'])),
    lookfor('INT'));

my $entire_input = concatenate($Expression, \&End_of_Input);

my @input = q[2 + 3 * (5 + 6)];

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
