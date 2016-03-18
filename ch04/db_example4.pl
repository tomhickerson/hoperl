#!/usr/bin/perl

# example of reading a log file backwards.  making it more appropriate for apache tomcat, since that's the thing I use everyday
use Iterator_Utils;
use FlatDB_Iterator;

# this should return a file backwards but tac apparently returns a file in a big glob and not line by line. so for now, we're just returning the
# file line by line instead

sub readbackwards {
    my $file = shift;
    # open my $fh, "|-", "tac", $file
    #    or return;
    # open my $fh, "|/usr/bin/tac $file" or return;
    open my $fh, "<", $file or return;
    return Iterator_Utils::Iterator { return scalar(<$fh>) };
}

my @fields = qw(ipaddress rfc931 username datetime timezone request page protocol htmlcode size referred agent);
my $logfile = readbackwards("localhost_access_log.txt");
my $db = FlatDB_Iterator->new($logfile, @fields);
# having some issues with callbackquery, so we can try just query for right now
# my $q = $db->callbackquery(sub {my %F=@_; $F{HTMLCODE} > 200 });
my $q = $db->query('HTMLCODE', '404');
while (1) {
    for (1..10) {
        my $rec = Iterator_Utils::NEXTVAL($q);
        print $rec;
    }
    print "q to quit - CR to continue?\n";
    chomp (my $resp = <STDIN>);
    last if $resp =~ /q/i;
}
