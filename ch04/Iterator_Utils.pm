#!/usr/bin/perl

# iterator_utils, a perl module we will use to store many of the iterator functions in this chapter

package Iterator_Utils;
use base Exporter;
@EXPORT_OK = qw(NEXTVAL Iterator append imap igrep iterate_function filehandle_iterator list_iterator);
%EXPORT_TAGS = ('all' => \@EXPORT_OK);

sub NEXTVAL { $_[0]->() }
sub Iterator (&) { return $_[0] }
