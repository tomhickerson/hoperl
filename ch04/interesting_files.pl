#!/usr/bin/perl

use Iterator_Utils;

# example of interesting-files and iterating thru a directory using our new module
# taken from page 127, chapter 4 of HOP

sub interesting_files {
    my $is_interesting = shift;
    my @queue = @_;
    return Iterator_Utils::Iterator {
        while (@queue) {
            my $file = shift @queue;
            if (-d $file) {
                opendir my $dh, $file or next;
                my @newfiles = grep {$_ ne "." && $_ ne ".."} readdir $dh;
                push @queue, map "$file/$_", @newfiles;
            }
            return $file if $is_interesting->($file);
        }
        return;
    };

}

sub contains_octopuses {
    my $file = shift;
    return unless -T $file && open my($fh), "<", $file;
    while (<$fh>) {
        return 1 if /octopus/i;
    }
    return;
}

my $octopus_file = interesting_files(\&contains_octopuses, '../..');
# trying to find our assignment from chapter 3
while (my $file = Iterator_Utils::NEXTVAL($octopus_file)) {
    print "Found $file\n";
}
