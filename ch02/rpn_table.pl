#!/usr/bin/perl

# reverse polish notation, taken from pp 74-75 of HOP, Chapter 2
# usage: ./rpn_table.pl "2 3 + 4 *"

my @stack;
my $actions = {
    '+' => sub { push @stack, pop(@stack) + pop(@stack) },
    '*' => sub { push @stack, pop(@stack) * pop(@stack) },
    '-' => sub { my $s = pop(@stack); push @stack, pop(@stack) - $s },
    '/' => sub { my $s = pop(@stack); push @stack, pop(@stack) / $s },
    'NUMBER' => sub { push @stack, $_[0] },
    '_DEFAULT_' => sub { die "Unrecognized token '$_[0]' aborting" }
};

my $result = evaluate($ARGV[0], $actions);
print "Result: $result\n";

sub evaluate {
    my ($expr, $actions) = @_;
    my @tokens = split /\s+/, $expr;

    for my $token (@tokens) {
        my $type;
        if ($token =~ /^\d+$/) {
            $type = 'NUMBER';
        }

        my $action = $actions->{$type} || $actions->{$token} || $actions->{_DEFAULT_};
        $action->($token, $type, $actions);
    }
    return pop(@stack);
}
