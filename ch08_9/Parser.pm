#!/usr/bin/perl

# creating the Parser from chapter 08, HOP
# updating Parser to allow for overloading from section 8.9 of HOP

package Parser;
use Stream ':all';
use base Exporter;
@EXPORT_OK = qw(parser nothing End_of_Input lookfor alternate concatenate star list_of operator T error action test L);
%EXPORT_TAGS = ('all' => \@EXPORT_OK);

# sub parser (&) { bless $_[0] => __PACKAGE__ };
sub parser (&);

sub nothing {
    my ($input, $continuation) = @_;
    return $continuation->($input);
}

sub null_list {
    my $input = shift;
    return ([], $input);
}

sub End_of_Input {
    my $input = shift;
    defined($input) ? () : (undef, undef);
}

sub single {
    my $v = shift;
    node($v, undef);
}

sub sunion {
    my ($s) = @_;
    my $cur_stream;
    while ($s && ! $cur_stream) {
        $cur_stream = head($s);
        $s = tail($s);
    }
    return undef unless $cur_stream;
    return node(head($cur_stream), promise { sunion(node(tail($cur_stream), $s)) });
}

# updated to allow for nested inputs from concatenate()
# update to allow for continuations
sub T {
    my ($parser, $transform) = @_;
    my $p = sub {
        my ($input, $continuation) = @_;
        if (my $v = $parser->($input, $continuation)) {
            $v = $transform->(@$v);
            return $v;
        } else {
            return;
        }
    };
    $N{$p} = $N{$parser};
    return $p;
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
        my ($input, $continuation) = @_;
        return unless defined $input;
        my $next = head($input);
        for my $i (0..$#$wanted) {
            next unless defined $wanted->[$i];
            unless ($wanted->[$i] eq $next->[$i]) {
                return undef;
            }
        }
        my $wanted_value = $value->($next, $u);
        return single([$wanted_value, tail($input)]);
    };
    $N{$parser} = "[@$wanted]";
    return $parser;
}

#sub concatenate {
#    my @p = @_;
#    return \&nothing if @p == 0;
#
#    my $parser = parser {
#        my $input = shift;
#        my $v;
#        my @values;
#        for (@p) {
#            ($v, $input) = $_->($input) or return;
#            push @values, $v;
#        }
        #return (\@values, $input);
#        return (bless(\@values => 'Pair'), $input);
#    }
#}

#sub concatenate2 {
#    my ($A, $B) = @_;
#    concatenate($A, $B);
#}

# providing the new concatenate here from p 477, but may replace it back with the above later

sub concatenate2 {
    my ($A, $B) = @_;
    my $p;
    $p = parser {
        my ($input, $continuation) = @_;
        my ($aval, $bval);
        my $BC = parser {
            my ($newinput) = @_;
            return unless $bval = $B->($newinput, $continuation);
        };
        $N{$BC} = "$N{$B} $N{$continuation}";
        if (($aval) = $A->($input, $BC)) {
            return ([$aval, $bval]);
        } else {
            return;
        }
    };
    $N{$p} = "$N{$A} $N{$B}";
    return $p;
}

sub concatenate {
    my (@p) = @_;
    return \&nothing if @p == 0;
    my $p0 = shift @p;
    return concatenate2($p0, concatenate(@p));
}

sub alternate {
    my @p = @_;
    return parser { return () } if @p == 0;
    return $p[0] if @p == 1;
    my $p;
    $p = parser {
        my ($input, $continuation) = @_;
        for (@p) {
            if (my ($v) = $_->($input, $continuation)) {
                return $v;
            }
        }
        return; # this is failure
    };
    $N{$p} = "(" . join(" | ", map $N{$_}, @p) . ")";
    return $p;
}

sub alternate2 {
    my ($A, $B) = @_;
    alternate($A, $B);
}

sub star {
    my $p = shift;
    my $p_star;
    $p_star = alternate(T(concatenate($p, parser { $p_star->(@_) }), sub { my ($first, $rest) = @_; [$first, @$rest];}), \&null_list);
}

sub list_of {
    my ($element, $separator) = @_;
    $separator = lookfor('COMMA') unless defined $separator;
    return concatenate($element, star(concat($separator, $element)));
}

sub operator {
    my ($subpart, @ops) = @_;
    my (@alternatives);
    for my $operator (@ops) {
        my ($op, $opfunc) = @$operator;
        push @alternatives, T(concatenate($op, $subpart), sub { my $subpart_value = $_[1];
                                                                sub { $opfunc->($_[0], $subpart_value) } });
    }
    my $result = T(concatenate($subpart, star(alternate(@alternatives))), sub { my ($total, $funcs) = @_;
                   for my $f (@$funcs) {
                       $total = $f->($total);
                   }
                                                                                $total; });
}

# note that originally the author wanted us to create _ as the function name, but later recanted this in the errata.  So, we pick L for Lookfor.
sub L { @_ = [@_]; goto &lookfor }

sub parser (&) { bless $_[0] => __PACKAGE__ };

use overload '-' => \&concatenate2,
    '|' => \&alternate2,
    '>>' => \&T,
    '""' => \&overload::StrVal;
# the author later states that we could use "" to pull out the parser name with a parser_name function, but we'll keep this for now

# adding the error subroutine from pages 429-430
sub error {
    my ($checker, $continuation) = @_;
    my $p;
    $p = parser {
        my $input = shift;
        #debug "Error in $N{$continuation}";
        #debug "Discaring up to $N{$checker}";
        my @discarded;
        while (defined($input)) {
            my $h = head($input);
            if (my (undef, $result) = $checker->($input)) {
                #debug "Discarding $N{$checker}";
                push @discarded, $N{$checker};
                $input = $result;
                last;
            } else {
                #debug "Discarding token [@$h]\n";
                push @discarded, $h->[1];
                drop($input);
            }
        }
        warn "Erroneous input: ignoring '@discarded'\n" if @discarded;
        return unless defined $input;
        $continuation->($input);
    };
    $N{$p} = "errhandler($N{$continuation} -> $N{$checker})";
    return $p;
}


sub debug (&) {
    return unless $DEBUG || $ENV{$DEBUG};
    my $msg = shift;
    my $i = 0;
    $i++ while caller($i);
    $I = "| " x ($i-2);
    print $I, $msg;
}

sub action {
    my $action = shift;
    return parser {
        my $input = shift;
        $action->($input);
        return (undef, $input);
    };
}

sub test {
    my $action = shift;
    return parser {
        my $input = shift;
        my $result = $action->($input);
        return $result ? (undef, $input) : ();
    };
}

1;
