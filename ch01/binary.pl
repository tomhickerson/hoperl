#!/usr/bin/perl

sub binary {
    my @params = @_;
    my $input = @params[0];
    return $input if $input == 0 || $input == 1;
    my $k = int($input/2);
    my $b = $input % 2;
    my $E = binary($k);
    return $E . $b;
}

print binary(37) . "\n";
print binary(215) . "\n";
print binary(4024) . "\n";
print binary(30245) . "\n";
print binary(400231) . "\n";
print binary(6476244) . "\n";
