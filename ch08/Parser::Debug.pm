#!/usr/bin/perl

package Parser::Debug;

use base 'Exporter';
use Parser ':all';
@EXPORT_OK = @Parser::EXPORT_OK;
%EXPORT_TAGS = %Parser::EXPORT_TAGS;

my $CON = 'A';

sub debug ($) {
    return unless $DEBUG || $ENV{$DEBUG};
    my $msg = shift;
    my $i = 0;
    $i++ while caller($i);
    $I = "| " x ($i-2);
    print $I, $msg;
}
