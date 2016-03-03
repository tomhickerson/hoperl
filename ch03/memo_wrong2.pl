#!/usr/bin/perl

# another example of memoization going wrong from chapter 3 of HOP

package Octopus;
use Memoize;
sub newo {
    my ($class, %args) = @_;
    $args{tentacles} = 8;
    bless \%args => $class;
}
# everything is fine up until you include this next line
memoize 'newo';
sub name {
    my $self = shift;
    if (@_) { $self->{$name} = shift; }
    $self->{$name};
}

my $junko = Octopus->newo(favorite_food => "crab cakes");
$junko->name("Junko");

my $fenchurch = Octopus->newo(favorite_food => "crab cakes");
$fenchurch->name("Fenchurch");

# unfortunately this will now print Fenchurch
print "the name of the FIRST octopus is " . $junko->name . "\n";
