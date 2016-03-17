#!/usr/bin/perl

# example of reading a log file backwards.  making it more appropriate for apache tomcat, since that's the thing I use everyday
use Iterator_Utils;
use FlatDB_Iterator;

sub readbackwards {
    my $file = shift;
    open my($fh), "|-", "tac", $file or return;
    return Iterator_Utils::Iterator { return scalar<$fh> };
}

my @fields = qw(ipaddress space1 space2 datetime timezone request page htmlcode size);
my $logfile = readbackwards("localhost_access_log.txt");
my $db = FlatDB_Iterator->new($logfile, @fields);
my $q = $db->callbackquery(sub {my %F=@_; $F{PAGE}=~ m{/Initial/$}; });
while (1) {
    for (1..10) {
        print Iterator_Utils::NEXTVAL($q) . "\n";
    }
    print "q to quit - CR to continue?\n";
    chomp (my $resp = <STDIN>);
    last if $resp =~ /q/i;
}
