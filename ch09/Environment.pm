#!/usr/bin/perl

package Environment;

# should there be a new here? we'll see shortly

sub subset {
    my ($self, $name) = @_;
    my %result;
    for my $k (keys %$self) {
        my $kk = $k;
        if ($kk =~ s/^\Q$name.//) {
            $result{$kk} = $self->{$k};
        }
    }
    $self->new(%result);
}
