#!/usr/bin/perl

# example of using the reduce function, with optional currying

sub reduce (&;$@) {
    my $code = shift;
    my $f = sub {
        my $base_val = shift;
        my $g = sub {
            my $val = $base_val;
            for (@_) {
                local ($a, $b) = ($val, $_);
                $val = $code->($val, $_);
            }
            return $val;
        };
        @_ ? $g->(@_) : $g;
    };
    @_ ? $f->(@_) : $f;
}

my @list = (1..21);
*listlength = reduce {$a + 1} 0;
print listlength(@list) . "\n";
