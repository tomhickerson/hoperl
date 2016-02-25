#!/usr/bin/perl

# reverse polish notation, taken from pp 74-75 of HOP, Chapter 2
# usage: ./rpn_table.pl "2 3 + 4 *"
use Data::Dumper;

my @stack;
my @stack2;
my $actions = {
    '+' => sub { push @stack, pop(@stack) + pop(@stack) },
    '*' => sub { push @stack, pop(@stack) * pop(@stack) },
    '-' => sub { my $s = pop(@stack); push @stack, pop(@stack) - $s },
    '/' => sub { my $s = pop(@stack); push @stack, pop(@stack) / $s },
    'NUMBER' => sub { push @stack, $_[0] },
    '_DEFAULT_' => sub { die "Unrecognized token '$_[0]' aborting" }
};

my $actions_2 = {
    'NUMBER' => sub { push @stack2, $_[0]},
    '_DEFAULT_' => sub { my $s = pop(@stack2); push @stack2, [$_[0], pop(@stack2), $s] }
};

my $input = $ARGV[0];
my $result = evaluate($input, $actions);

# populate the second stack here
my $formula = evaluate($input, $actions_2);
my $newformula = AST_to_string(@stack2);
print "Formula: $newformula\n";
print "Result: $result\n";

# adding data dumper here and taking a look at the AST we have created
print "Stack2: " . Dumper(@stack2) . "\n";

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

# update: generating the AST to String function from page 76 of HOP, including return statements
sub AST_to_string {
    my ($tree) = @_;
    if (ref $tree) {
        my ($op, $a1, $a2) = @$tree;
        my ($s1, $s2) = (AST_to_string($a1), AST_to_string($a2));
        return "($s1 $op $s2)";
    } else {
        return $tree;
    }
}
