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
    my ($p1, $p2) = @_;
    my $parser = parser {
        my $input0 = shift;
        my ($v1, $input1) = $p1->($input0) or return;
        my ($v2, $input2) = $p2->($input1) or return;
        return ([$v1, $v2], $input2);
    }
}
