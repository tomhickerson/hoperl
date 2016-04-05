#!/usr/bin/perl

use Stream 'node', 'promise', 'show';

# creating a sequence of carrots, from page 264 of HOP

my $carrots;
# defining the above because we need to use this as a global variable

$carrots = node('carrot', promise { $carrots });

show($carrots, 10);
