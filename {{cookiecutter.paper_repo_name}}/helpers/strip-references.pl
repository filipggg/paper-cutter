#!/usr/bin/perl

use strict;

my @previously_skipped = ();

my $was_reference = 0;

while (my $line=<STDIN>) {
    chomp $line;

    if ($line =~ /^References$/) {
        if ($was_reference) {
            for my $pline (@previously_skipped) {
                print "$pline\n";
            }
            @previously_skipped = ();
        } else {
            $was_reference = 1;
        }
    }

    if ($was_reference) {
        push @previously_skipped, $line;
    } else {
        print "$line\n";
    }
}
