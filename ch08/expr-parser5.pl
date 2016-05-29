#!/usr/bin/perl

# third example from chapter 08 about lexers and parsers
# trying to group the multiplication signed numbers together
# adding the transform function T
# now, instead of just grouping, we are going to calculate the numbers using transform
# also, adding the ability to read subtraction the correct way, per section 8.4.2

use Parser ':all';
use Lexer ':all';

my ($expression, $term, $factor, $expression_tail);

my $Expression = parser { $expression->(@_) };
my $Term = parser { $term->(@_) };
my $Factor = parser { $factor->(@_) };
my $Expression_tail = parser { $expression_tail->(@_) };

$expression = T(concatenate($Term, $Expression_tail), sub {$_[1]->($_[0])});

$term = alternate(T(concatenate($Factor, lookfor(['OP', '*']), $Term), sub { [$_[0] * $_[2]] }), $Factor);

$factor = alternate(lookfor('INT'), T(concatenate(lookfor(['OP', '(']), $Expression, lookfor(['OP', ')'])), sub { $_[1] }));

$expression_tail = alternate(T(concatenate(lookfor(['OP', '+']), $Term, $Expression_tail), sub {
    my ($op, $tv, $rest) = @_;
    sub { $rest->($_[0] + $tv)}
                               }),
    T(concatenate(lookfor(['OP', '-']), $Term, $Expression_tail), sub {
        my ($op, $tv, $rest) = @_;
        sub {$rest->($_[0] - $tv)}
      }),
    T(\&nothing, sub { sub { $_[0] } }));

my $entire_input = T(concatenate($Expression, \&End_of_Input), sub { $_[0] });

my @input = q[8 - 3 - 4];
# will now return 1, since we are looking in the 'correct' direction

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
