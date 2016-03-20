#!/usr/bin/perl

# iterator_utils, a perl module we will use to store many of the iterator functions in this chapter

package Iterator_Utils;
use base Exporter;
@EXPORT_OK = qw(NEXTVAL Iterator append imap igrep iterate_function filehandle_iterator list_iterator);
%EXPORT_TAGS = ('all' => \@EXPORT_OK);

sub NEXTVAL { $_[0]->() }
sub Iterator (&) { return $_[0] }
sub filehandle_iterator {
    my $fh = shift;
    return Iterator { <$fh> };
}
sub iterate_function {
    my $n = 0;
    my $f = shift;
    return Iterator { return $f->($n++); };
}

sub imap (&$) {
    my ($transform, $it) = @_;
    return Iterator {
        local $_ = NEXTVAL($it);
        return unless defined $_;
        return $transform->();
    };
}

sub igrep (&$) {
    my ($is_interesting, $it) = @_;
    return Iterator {
        local $_;
        while (defined ($_ = NEXTVAL($it))) {
            return $_ if $is_interesting->();
        }
        return;
    };
}

sub list_iterator {
    my @items = @_;
    return Iterator {
        return shift @items;
    };
}

sub append {
    my @its = @_;
    return Iterator {
        while (@its) {
            my $val = NEXTVAL($its[0]);
            return $val if defined $val;
            shift @its; # discard exhausted operator
        }
        return;
    };
}
