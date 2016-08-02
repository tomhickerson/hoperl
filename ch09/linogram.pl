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
                                 }])); #adding identifier later
