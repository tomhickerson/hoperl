#!/usr/bin/perl

# creating the Parser from chapter 08, HOP

package Parser;
use Stream ':all';
use base Exporter;
@EXPORT_OK = qw(parser nothing End_of_Input lookfor alternate concatenate star list_of operator T error action test);
%EXPORT_TAGS = ('all' => \@EXPORT_OK);

sub parser (&);

sub nothing {
    my $input = shift;
    return (undef, $input);
}

sub End_of_Input {
    my $input = shift;
    defined($input) ? () : (undef, undef);
}

sub T {
    my ($parser, $transform) = @_;
    return parser {
        my $input = shift;
        if (my($value, $newinput) = $parser->($input)) {
            $value = $transform->(@$value);
            return ($value, $newinput);
        } else {
            return;
        }
    };
}

sub INT {
    my $input = shift;
    return unless defined $input;
    my $next = head($input);
    return unless $next->[0] eq 'INT';
    my $token_value = $next->[1];
    return ($token_value, tail($input));
}

# another token recognizing function, as compared to INT above
sub lookfor {
    my $wanted = shift;
    my $value = shift || sub { $_[0][1] };
    my $u = shift;
    $wanted = [$wanted] unless ref $wanted;
    my $parser = parser {
        my $input = shift;
        return unless defined $input;
        my $next = head($input);
        for my $i (0..$#$wanted) {
            next unless defined $wanted->[$i];
            return unless $wanted->[$i] eq $next->[$i];
        }
        my $wanted_value = $value->($next, $u);
        return ($wanted_value, tail($input));
    };
    return $parser;
}

sub parser (&) { $_[0] }

sub concatenate {
    my @p = @_;
    return \&nothing if @p == 0;

    my $parser = parser {
        my $input = shift;
        my $v;
        my @values;
        for (@p) {
            ($v, $input) = $_->($input) or return;
            push @values, $v;
        }
        return (\@values, $input);
    }
}

sub alternate {
    my @p = @_;
    return parser { return () } if @p == 0;
    return $p[0] if @p == 1;
    my $parser = parser {
        my $input = shift;
        my ($v, $newinput);
        for (@p) {
            if (($v, $newinput) = $_->($input)) {
                return ($v, $newinput);
            }
        }
        return;
    };
}

sub star {
    my $p = shift;
    my $p_star;
    $p_star = alternate(concatenate($p, parser { $p_star->(@_) }), \&nothing);
}

sub list_of {
    my ($element, $separator) = @_;
    $separator = lookfor('COMMA') unless defined $separator;
    return concatenate($element, star(concat($separator, $element)));
}

1;
