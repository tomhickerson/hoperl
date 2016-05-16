#!/usr/bin/perl

# first code for Chapter 08; creating a Lexer package

package Lexer;

use base 'Exporter';
@EXPORT_OK = qw(make_charstream blocks records tokens iterator_to_stream make_lexer allinput);

%EXPORT_TAGS = ('all' => \@EXPORT_OK);

sub make_charstream {
    my $fh = shift;
    return sub { return getc($fh) };
}

sub records {
    my $chars = shift;
    my $terminator = @_ ? shift : $/;
    my $buffer = "";
    sub {
        my $char;
        while (substr($buffer, -(length $terminator)) ne $terminator && defined($char = $chars->())) {
            $buffer .= $char;
        }
        if ($buffer ne "") {
            my $line = $buffer;
            $buffer = "";
            return $line;
        } else {
            return;
        }
    }
}
