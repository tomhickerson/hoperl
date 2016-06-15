#!/usr/bin/perl

# Parsing the outline points for a list here.  Slightly different departure from regex and arithmetic.

use Lexer ':all';
use Stream 'node';

my ($tree, $subtree);
sub outline_to_array {
    my @input = @_;
    my $input = sub { shift @input };
    my $lexer = iterator_to_stream(make_lexer($input,
                                              ['ITEM', qr/^.*$/m], ['NEWLINE', qr/\n+/, sub { "" }],));
    my ($result) = $tree->($lexer);
    return $result;
}
use Parser ':all';
use Stream 'head';

my $Tree = parser { $tree->(@_) };
my $Subtree = parser { $subtree->(@_) };
my @LEVEL;
$tree = T(concatenate(T(lookfor('ITEM', sub { $_[0] }),
                      sub {
                        my $s = $_[1];
                        push @LEVEL, level_of($s);
                        return trim($s);
                        }),
          star($Subtree),
          action(sub { pop @LEVEL })),
    sub { [ $_[0], @{$_[1]} ] },
    );

$subtree = T(concatenate(test(sub {
                              my $input = shift;
                              return unless $input;
                              my $next = head($input);
                              return unless $next->[0] eq 'ITEM';
                              return level_of($next->[1]) > $LEVEL[-1];
                              }), $Tree,), sub { $_[1] });


my $BULLET = '[#*ox.+-]\s+';
sub trim {
    my $s = shift;
    $s =~ s/^ *//;
    $s =~ s/^$BULLET//o;
    return $s;
}

my $PREFIX;
sub level_of {
    my $count = 0;
    my $s = shift;
    if (! defined $PREFIX) {
        ($PREFIX) = $s =~ /^(\s*)/;
    }
    $s =~ s/^$PREFIX//o or die "Item $s was not indented the same as the previous items\n";
    my ($indent) = $s =~ /^(\s*)/;
    my $level = length($indent);
    return $level;
}

my $text = '* An
  * Outline
  * Is
     * Always
    * Necessary
  * To
  * Test
    * this
    * program
    * as
    * it could be
     * a little
    * flaky';

my $ary = outline_to_array($text);
use Data::Dumper;
print Dumper($ary);
