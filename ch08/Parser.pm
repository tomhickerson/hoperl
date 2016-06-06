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

sub null_list {
    my $input = shift;
    return ([], $input);
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


1;
