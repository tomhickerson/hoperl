#!/usr/bin/perl

# Stream module, from page 258 of HOP, chapter 06.
# the module on which all other problems will run; expect changes to this module over the course of the chapter.

package Stream;
use base Exporter;
@EXPORT_OK = qw(node head tail drop upto upfrom show promise filter transform merge list_to_stream cutsort cut_bylen iterate_function cut_loops);

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

# modifying tail from pages 268-269 from HOP to memoize
sub tail {
    my ($s) = @_;
    if (is_promise($s->[1])) {
        $s->[1] = $s->[1]->();
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

sub drop {
    my $h = head($_[0]);
    $_[0] = tail($_[0]);
    return $h;
}

sub show {
    my ($s, $n) = @_;
    while ($s && (! defined $n || $n-- > 0)) {
        print drop($s) . $";
    }
    print $/;
}

sub transform (&$) {
    my $f = shift;
    my $s = shift;
    return unless $s;
    node($f->(head($s)), promise { transform($f, tail($s))});
}

sub filter (&$) {
    my $f = shift;
    my $s = shift;
    until (! $s || $f->(head($s))) {
        drop($s);
    }
    return if ! $s;
    node(head($s), promise { filter($f, tail($s)) });
}

# changing this function per page 304 of HOP
sub iterate_function {
    my ($f, $x) = @_;
    my $s;
    $s = node($x, promise { &transform($f, $s) });
}

# adding merge from page 271 of HOP
sub merge {
    my ($S, $T) = @_;
    return $T unless $S;
    return $S unless $T;
    my ($s, $t) = (head($S), head($T));
    if ($s > $t) {
        node($t, promise {merge($S, tail($T))});
    } elsif ($s < $t) {
        node($s, promise {merge(tail($S), $T)});
    } else {
        node($s, promise {merge(tail($S), tail($T))});
    }
}

# adding list_to_stream and cutsort from pages 290-291
sub cut_bylen {
    my ($a, $b) = @_;
    length($a) < length($b);
}

sub list_to_stream {
    my $node = pop;
    while (@_) {
        $node = node(pop, $node);
    }
    $node;
}

sub insert (\@$$);

sub cutsort {
    my ($s, $cmp, $cut, $pending) = @_;
    my @emit;

    while ($s) {
        while (@pending && $cut->($pending[0], head($s))) {
            push @emit, shift @pending;
        }

        if (@emit) {
            return list_to_stream(@emit, promise { cutsort($s, $cmp, $cut, $pending) });
        } else {
            insert(@pending, head($s), $cmp);
            $s = tail($s);
        }
    }
    return list_to_stream(@pending, undef);
}

sub insert (\@$$) {
    my ($a, $e, $cmp) = @_;
    my ($lo, $hi) = (0, scalar(@$a));
    while ($lo < $hi) {
        my $med = int(($lo + $hi) / 2);
        my $d = $cmp->($a->[$med], $e);
        if ($d <= 0) {
            $lo = $med + 1;
        } else {
            $hi = $med;
        }
    }
    splice(@$a, $lo, 0, $e);
}

# adding the cut_loops function from pp 308-309 from HOP

sub cut_loops {
    my $s = shift;
    return unless $s;
    my @previous_values = @_;
    for (@previous_values) {
        if (head($s) == $_) {
            return;
        }
    }
    node(head($s), promise { cut_loops(tail($s), head($s), @previous_values) });
}
