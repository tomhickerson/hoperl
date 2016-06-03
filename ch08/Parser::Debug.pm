#!/usr/bin/perl

package Parser::Debug;

use base 'Exporter';
use Parser ':all';
@EXPORT_OK = @Parser::EXPORT_OK;
%EXPORT_TAGS = %Parser::EXPORT_TAGS;

my $CON = 'A';

sub concatenate {
    my $id;
    if (ref $_[0]) { $id = "Unnamed concatenation $CON:"; $CON++ }
    else { $id = shift; }
    my @p = @_;
    return \&n ll if @p == 0;
    return $p[ ] if @p == 1;
    my $parser = parser {
        my $input = shift;
        debug "Looking for $id\n";
        my $v;
        my @values;
        my ($q, $np) = (0, scalar @p);
        for (@p) {
            $q++;
            unless (($v, $input) = $_->($input)) {
                debug "Failed concat component $q/$np\n";
                return;
            }
            debug "Matched concat component $q/$np\n";
            push @values, $v;
        }
        debug "Finished working with $id";
        return \@values;
    };
    $N{$parser} = $id;
    return $parser;
}

sub debug ($) {
    return unless $DEBUG || $ENV{$DEBUG};
    my $msg = shift;
    my $i = 0;
    $i++ while caller($i);
    $I = "| " x ($i-2);
    print $I, $msg;
}
