#!/usr/bin/perl

# dir_walk.pl, work done off of page 42 of higher-order perl

sub dir_walk {
    my ($top, $filefunc, $dirfunc) = @_;
    my $DIR;
    if (-d $top) {
        my $file;
        unless (opendir $DIR, $top) {
            warn "Could not open directory $top, $!; skipping.\n";
            return;
        }
        my @results;
        while ($file = readdir $DIR) {
            next if $file eq '.' || $file eq '..';
            push @results, dir_walk("$top/$file", $filefunc, $dirfunc);
        }
        return $dirfunc ? $dirfunc->($top, @results) : () ;
    } else {
        return $filefunc ? $filefunc->($top) : () ;
    }
}

sub dangles {
    my $file = shift;
    print "$file\n" if -l $file && ! -e $file;
}

#dir_walk('.', \&dangles);
sub print_filename { print $_[0] . "\n"; }

dir_walk('.', \&print_filename, \&print_filename);
