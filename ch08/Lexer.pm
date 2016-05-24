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
    my $input = shift;
    my $terminator = @_ ? shift : quotemeta($/);
    my @records;
    my @newrecs = split /($terminator)/, $input;
    while (@newrecs > 2) {
        push @records, shift(@newrecs).shift(@newrecs);
    }
    push @records, @newrecs;
    return sub {
        return shift @records;
    }
}

sub tokens {
    my ($input, $label, $pattern, $maketoken) = @_;
    $maketoken ||= sub { [ $_[1], $_[0]]};
    my @tokens;
    my ($buf, $finished) = ("");
    my $split = sub { split /$pattern/, $_[0] };
    sub {
        while (@tokens == 0 && ! $finished) {
            my $i = $input->();
            if (ref $i) {
                # input is a token
                my ($sep, $tok) = $split->($buf);
                $tok = $maketoken->($tok, $label) if defined $tok;
                push @tokens, grep defined && $_ ne "", $sep, $tok, $i;
                $buf = "";
                last;
            } else {
                # input is an untokenized string
                $buf .= $i if defined $i;
                my @newtoks = $split->($buf);
                while (@newtoks > 2 || @newtoks && !defined $i) {
                    # buffer contains complete separator and complete token
                    # or we have reached the end of the input
                    push @tokens, shift(@newtoks);
                    push @tokens, $maketoken->(shift(@newtoks), $label) if @newtoks;
                }
                # reassemble last contents of buffer
                $buf = join "", @newtoks;
                undef $buf if ! defined $i;
                @tokens = grep $_ ne "", @tokens;
            }
        }
        return shift(@tokens);
    }
}

sub allinput {
    my $fh = shift;
    my @data;
    {
        local $/;
        $data[0] = <$fh>;
    }
    sub { return shift @data };
}

sub blocks {
    my $fh = shift;
    my $blocksize = shift || 8192;
    sub {
        return unless read $fh, my($block), $blocksize;
        return $block;
    }
}

sub make_lexer {
    my $lexer = shift;
    while (@_) {
        my $args = shift;
        $lexer = tokens($lexer, @$args);
    }
    $lexer;
}

use Stream 'node';

sub iterator_to_stream {
    my $it = shift;
    my $v = $it->();
    return unless defined $v;
    node($v, sub { iterator_to_stream($it) });
}

1;
