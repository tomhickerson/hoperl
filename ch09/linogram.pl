#!/usr/bin/perl

# linogram.pl, the running program for our libraries of dynamic-oriented code
# first, let's set up the lexer

use Parser ':all';
use Lexer ':all';

my $input = sub { read INPUT, my($buf), 8192 or return; $buf };

my @keywords = map [uc($_), qr/\b$_\b/], qw(constraints define extend draw);

my $tokens = iterator_to_stream(make_lexer($input, @keywords,
                                ['ENDMARKER', qr/__END__.*/s,
                                 sub {
                                     my $s = shift;
                                     $s =~ s/^__END__\s//;
                                     ['ENDMARKER', $s]
                                 }],
                                ['IDENTIFIER', qr/[a-zA-Z_]\w*/],
                                ['NUMBER', qr/(?: \d+ (?: \.\d+)? | \.\d+)(?: [eE] \d+)? /x],
                                ['FUNCTION', qr/&/],
                                ['DOT', qr/\./],
                                ['COMMA', qr/,/],
                                ['OP', qr|[-+*/]|],
                                ['EQUALS', qr/=/],
                                ['LPARENS', qr/[(]/],
                                ['RPARENS', qr/[)]/],
                                ['LBRACE', qr/[{]/],
                                ['RBRACE', qr/[}]\n*/],
                                ['TERMINATOR', qr/;\n*/],
                                ['WHITESPACE', qr/\s+/, sub { "" }])); #all the items, more later?

# the main data structure in linogram is Types. which is a hash mapping known Type names to the objects that represent them.
my $ROOT_TYPE = Type->new('ROOT');
my %TYPES = ('number' => Type::Scalar->new('number'), 'ROOT' => $ROOT_TYPE);

# top level parser for our linogram
$program = star($Definition | $Declaration
    > sub { add_declarations($ROOT_TYPE, $_[0])}
    ) - option($perl_code) - $End_of_input;

$perl_code = _("ENDMARKER") > sub { eval $_[0]; die if $@; };
