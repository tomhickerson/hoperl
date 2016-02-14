#!/usr/bin/perl

sub hanoi {
    my ($n, $start, $end, $extra, $move_disk) = @_;
    if ($n == 1) {
        $move_disk->(1, $start, $end);
    } else {
        hanoi($n-1, $start, $extra, $end, $move_disk);
        $move_disk->($n, $start, $end);
        hanoi($n-1, $extra, $end, $start, $move_disk);
    }
}

sub print_instruction {
    my ($disk, $start, $end) = @_;
    print ("Moving disk #$disk from $start to $end.\n");
}

hanoi(3, 'A', 'C', 'B', \&print_instruction);
