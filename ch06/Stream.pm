#!/usr/bin/perl

# Stream module, from page 258 of HOP, chapter 06.
# the module on which all other problems will run; expect changes to this module over the course of the chapter.

package Stream;
use base Exporter;
@EXPORT_OK = qw(node head tail drop upto upfrom show promise filter transfer merge list_to_stream cutsort iterate_function cut_loops);

%EXPORT_TAGS = ('all' => \@EXPORT_OK);

sub node {
    my ($h, $t) = @_;
    [$h, $t];
}

sub head {
    my ($s) = @_;
    $s->[0];
}

sub is_promise {
    UNIVERSAL::isa($_[0], 'CODE');
}

sub tail {
    my ($s) = @_;
    if (is_promise($s->[1])) {
        return $s->[1]->();
    }
    $s->[1];
}

sub promise(&) { $_[0] }

sub upto {
    my ($m, $n) = @_;
    return if $m > $n;
    node($m, promise { upto($m+1, $n) });
}

sub upfrom {
    my ($m) = @_;
    node($m, promise { upfrom($m+1) });
}

sub show {
    my ($s, $n) = @_;
    while ($s && (! defined $n || $n-- > 0)) {
        print head($s) . $";
        $s = tail($s);
    }
    print $/;
}
