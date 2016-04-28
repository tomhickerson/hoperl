#!/usr/bin/perl

# the Regex package, from chapter 06 of HOP

package Regex;
use Stream ':all';
use base 'Exporter';
@EXPORT_OK = qw(literal union concat star plus charclass show2 matches);

sub literal {
    my $string = shift;
    node($string, undef);
}

sub index_of_shortest {
    my @s = @_;
    my $minlen = length(head($s[0]));
    my $si = 0;
    for (1..$#s) {
        my $h = head($s[$_]);
        if (length($h) < $minlen) {
            $minlen = length($h);
            $si = $_;
        }
    }
    $si;
}

sub union {
    my (@s) = grep $_, @_;
    return unless @s;
    return $s[0] if @s == 1;
    my $si = index_of_shortest(@s);
    node(head($s[$si]), promise {
        union(map $_ == $si ? tail($s[$_]) : $s[$_], 0..$#s) });
}

sub precat {
    my ($s, $c) = @_;
    transform { "$c$_[0]" } $s;
}

sub postcat {
    my ($s, $c) = @_;
    transform { "$_[0]$c" } $s;
}

sub concat {
    my ($S, $T) = @_;
    return unless $S && $T;
    my ($s, $t) = (head($S), head($T));

    node("$s$t", promise { union(postcat(tail($S), $t),
                                 precat(tail($T), $s),
                                 concat(tail($S), tail($T)))});
}

sub star {
    my $s = shift;
    my $r;
    $r = node("", promise { concat($s, $r) });
}

# changing show to show2 to differentiate from Stream::show
sub show2 {
    my ($s, $n) = @_;
    while ($s && (! defined $n || $n-- > 0)) {
        print qq{"}, drop($s), qq{"\n};
    }
    print "\n";
}

# charclass('acd') = /^[acd]$/
sub charclass {
    my $class = shift;
    union(map literal($_), split(//, $class));
}

# plus($s) = /^s+$/
sub plus {
    my $s = shift;
    concat($s, star($s));
}
