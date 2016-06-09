#!/usr/bin/perl

use Lexer ':all';
use Stream 'node', 'show';

my ($regex, $alternative, $atom, $qatom);
sub regex_to_stream {
    my @input = @_;
    my $input = sub { shift @input };

    my $lexer = iterator_to_stream(make_lexer($input,
                                   ['ATOM', qr/\\x[0-9a-fA-F]{0,2}|\\\d+|\\./x,],
                                   ['PAREN', qr/[()]/,],
                                   ['QUANT', qr/[*+?]/ ],
                                   ['BAR', qr/[|]/, ],
                                   ['ATOM', qr/./, ]
                                   )
        );

    my ($result) = $regex->($lexer);
    return $result;
}

use Parser ':all';
use Regex;

my $Regex = parser { $regex->(@_)};
my $Alternative = parser { $alternative->(@_)};
my $Atom = parser { $atom->(@_)};
my $QAtom = parser { $qatom->(@_)};

$regex = alternate(T(concatenate($Alternative, lookfor('BAR'), $Regex), sub { Regex::union($_[0], $_[2])}), $Alternative);
$alternative = alternate(T(concatenate($QAtom, $Alternative), \&Regex::concat), T(\&nothing, sub { Regex::literal("")}));
my %quant;
$qatom = T(concatenate($Atom, alternate(lookfor('QUANT'), \&nothing),
           ),
           sub { my($at, $q) = @_; defined $q ? $quant{$q}->($at) : $at });

%quant = ('*' => \&Regex::star, '+' => \&Regex::plus, '?' => \&Regex::query);

$atom = alternate(lookfor('ATOM', sub { Regex::literal($_[0][1]) }),
    T(concatenate(lookfor(['PAREN', '(']), $Regex, lookfor(['PAREN', ')']),
      ), sub { $_[1] }),
    );

my $stream = regex_to_stream("(a|b)+(c|d*)");
show($stream, 10);
