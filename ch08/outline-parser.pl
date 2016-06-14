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
my $LEVEL = 0;
$tree = T(concatenate(lookfor('ITEM', sub { trim($_[0][1]) }),
    action(sub { $LEVEL++ }),
    star($Subtree),
    action(sub { $LEVEL-- })),
    sub { [ $_[0], @{$_[2]}]});

$subtree = T(concatenate(test(sub {
                              my $input = shift;
                              return unless $input;
                              my $next = head($input);
                              return unless $next->[0] eq 'ITEM';
                              return level_of($next->[1]) >= $LEVEL;
                              }), $Tree,), sub { $_[1] });


my $BULLET = '[#*ox.+-]\s+';
sub trim {
    my $s = shift;
    $s =~ s/^ *//;
    $s =~ s/^$BULLET//o;
    return $s;
}

sub level_of {
    my ($space) = $_[0] =~ /^( *)/;
    return length($space)/2;
}

my $text = '* An
  * Outline
  * Is
    * Necessary
  * To
  * Test
    * this
      * program';

my $ary = outline_to_array($text);
use Data::Dumper;
print Dumper($ary);
