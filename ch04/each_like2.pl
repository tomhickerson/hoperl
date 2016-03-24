#!/usr/bin/perl

# each like, a mapping function from pages 182-183 from HOP chapter 4

use Iterator_Utils;

sub eachlike (&$) {
    my ($transform, $it) = @_;
    return Iterator_Utils::Iterator {
        local $_ = Iterator_Utils::NEXTVAL($it);
        return unless defined $_;
        my $value = $transform->();
        return wantarray ? ($_, $value) : $value;
    };
}

sub upto {
    my ($m, $n) = @_;
    return Iterator_Utils::Iterator { return $m <= $n ? $m++ : undef; };
}

sub dir_walk {
    my @queue = shift;
    return Iterator_Utils::Iterator {
        if (@queue) {
            my $file = shift @queue;
            if (-d $file) {
                opendir my $dh, $file or next;
                my @newfiles = grep{$_ ne "." && $_ ne ".."} readdir $dh;
                push @queue, map "$file/$_", @newfiles;
            }
            return $file;
        } else {
            return;
        }
    };
}

my $n = eachlike { -l && ! -e } dir_walk('../../..');
while (my ($filename, $badlink) = Iterator_Utils::NEXTVAL($n)) {
    print "$filename is a dangling link\n" if $badlink;
}

my $n2 = eachlike { $_ eq "upto.pl"} dir_walk('../..');
while (my $name = Iterator_Utils::NEXTVAL($n2)) {
    print "found $name\n";
}
